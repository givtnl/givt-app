import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class ReflectAndShareRepository {
  ReflectAndShareRepository(
      this._profilesRepository, this._familyApiService, this._authRepository) {
    _init();
  }

  final ProfilesRepository _profilesRepository;
  final FamilyAPIService _familyApiService;
  final FamilyAuthRepository _authRepository;

  int completedLoops = 0;
  int totalQuestionsAsked = 0;
  int _generousDeeds = 0;
  int totalTimeSpentInSeconds = 0;
  DateTime? _startTime;
  DateTime? _endTime;
  String? _gameId;
  List<GameProfile>? _allProfiles;
  List<GameProfile> _selectedProfiles = [];
  final List<String> _usedSecretWords = [];
  String? _currentSecretWord;

  GameStats? _gameStatsData;

  final StreamController<GameStats> _gameStatsStreamController =
      StreamController.broadcast();

  Stream<GameStats> onGameStatsChanged() => _gameStatsStreamController.stream;

  int getAmountOfGenerousDeeds() => _generousDeeds;

  Future<void> _init() async {
    _authRepository.authenticatedUserStream().listen(
      (user) {
        if (user != null) {
          _clearData();
          _fetchGameStats();
        } else {
          _clearData();
        }
      },
    );
  }

  void _clearData() {
    _allProfiles = null;
    _selectedProfiles = [];
    _gameStatsData = null;
  }

  void incrementGenerousDeeds() {
    _generousDeeds++;
  }

  Future<void> saveSummaryStats() async {
    try {
      _endTime = DateTime.now();
      totalTimeSpentInSeconds = _endTime!.difference(_startTime!).inSeconds;
      await _familyApiService.saveGratitudeStats(
          totalTimeSpentInSeconds, _gameId);
      await _fetchGameStats();
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
  }

  void shareAudio(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        //TODO use game guid
        _familyApiService.uploadAudioFile(_gameId!, file);
        file.delete();
      }
    } on Exception catch (e) {
      print(e);
      // TODO what if fails
    }
  }

  Future<void> saveGratitudeInterestsForCurrentSuperhero(
      GratitudeCategory? gratitude) async {
    _selectedProfiles[_getCurrentSuperHeroIndex()] =
        _selectedProfiles[_getCurrentSuperHeroIndex()]
            .copyWith(gratitude: gratitude);
    try {
      await _familyApiService.saveUserGratitudeCategory(
          _gameId!,
          _selectedProfiles[_getCurrentSuperHeroIndex()].userId,
          gratitude?.displayText ?? '');
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
  }

  GratitudeCategory? getGratitudeInterestsForCurrentSuperhero() {
    return _selectedProfiles[_getCurrentSuperHeroIndex()].gratitude;
  }

  List<GameProfile> getCurrentReporters() {
    return _selectedProfiles
        .where((profile) => profile.roles.whereType<Reporter>().isNotEmpty)
        .toList();
  }

  Future<List<Profile>> getKidsWithoutBedtime() async {
    try {
      final profiles = await _profilesRepository.getProfiles();
      return profiles
          .where(
            (profile) =>
                profile.isChild &&
                (profile.bedTime == null || profile.windDownTime == null),
          )
          .toList();
    } on Exception catch (e, s) {
      LoggingInfo.instance.error(
        'Failed to get kids without bedtime',
        methodName: s.toString(),
      );
      rethrow;
    }
  }

  // complete a game loop/ round
  // return TRUE when all family members have been the superhero and the game should end, FALSE otherwhise
  void completeLoop() {
    completedLoops++;
  }

  // get all possibly family members that can play the game
  Future<List<GameProfile>> getFamilyProfiles() async {
    if (_allProfiles != null) {
      return _allProfiles!;
    }
    final profiles = await _profilesRepository.getProfiles();
    _allProfiles = profiles.map((profile) => profile.toGameProfile()).toList();
    return _allProfiles!;
  }

//list of adult users that did not play in this game
  Future<List<Profile>> missingAdults() async {
    final profiles = await _profilesRepository.getProfiles();
    final missingAdults = profiles
        .where((profile) => profile.isAdult)
        .where((profile) => !_selectedProfiles
            .map((selectedProfile) => selectedProfile.userId)
            .contains(profile.id))
        .toList();
    return missingAdults;
  }

  void emptyAllProfiles() {
    _allProfiles = null;
  }

  String? getGameId() => _gameId;

  Future<void> createGameSession() async {
    try {
      _gameId = await _familyApiService.createGame();
    } catch (e, s) {
      _gameId = null;
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
  }

  // select the family members that will participate in the game
  void selectProfiles(List<GameProfile> selectedProfiles) {
    // Reset game state
    createGameSession();
    completedLoops = 0;
    totalQuestionsAsked = 0;
    _generousDeeds = 0;
    totalTimeSpentInSeconds = 0;
    _startTime = DateTime.now();

    _selectedProfiles = selectedProfiles;
  }

  // randomly assign roles to the selected family members (superhero, sidekick, reporter)
  List<GameProfile> randomlyAssignRoles() {
    final rng = Random();
    int sidekickIndex;
    final superheroIndex = rng.nextInt(_selectedProfiles.length);
    if (_isLastIndex(superheroIndex)) {
      sidekickIndex = 0;
    } else {
      sidekickIndex = superheroIndex + 1;
    }

    return _setProfiles(superheroIndex, sidekickIndex, rng);
  }

  // assign roles for the next round
  List<GameProfile> assignRolesForNextRound() {
    final rng = Random();
    final superheroIndex = _getCurrentSuperHeroIndex();
    int newSuperheroIndex;
    int newSideKickIndex;
    if (_isLastIndex(superheroIndex)) {
      newSuperheroIndex = 0;
      newSideKickIndex = 1;
    } else {
      newSuperheroIndex = superheroIndex + 1;
      if (_isLastIndex(newSuperheroIndex)) {
        newSideKickIndex = 0;
      } else {
        newSideKickIndex = newSuperheroIndex + 1;
      }
    }

    return _setProfiles(newSuperheroIndex, newSideKickIndex, rng);
  }

  List<GameProfile> _setProfiles(
    int superheroIndex,
    int sidekickIndex,
    Random rng,
  ) {
    final previousTurnList = _selectedProfiles;
    // Assign superhero and sidekick roles
    _selectedProfiles[superheroIndex] =
        previousTurnList[superheroIndex].copyWith(
      role: const Role.superhero(),
    );
    _selectedProfiles[sidekickIndex] = previousTurnList[sidekickIndex].copyWith(
      role: const Role.sidekick(),
    );

    if (_selectedProfiles.length == 2) {
      return _setReportersWithTwoPlayers(sidekickIndex, rng);
    }
    return _setReportersWithMoreThanTwoPlayers(
        superheroIndex, sidekickIndex, rng);
  }

  List<GameProfile> _setReportersWithMoreThanTwoPlayers(
      int superheroIndex, int sidekickIndex, Random rng) {
    // Get all the rest as reporters
    final preReporters = <GameProfile>[];
    _selectedProfiles.asMap().forEach((index, profile) {
      if (index != superheroIndex && index != sidekickIndex) {
        preReporters.add(profile);
      }
    });

    final reportersWithQuestions =
        _assignQuestionsToReporters(preReporters, rng);

    // Assign the reporter roles with questions
    _selectedProfiles.asMap().forEach((index, profile) {
      if (index != superheroIndex && index != sidekickIndex) {
        final reporter = reportersWithQuestions.firstWhere(
            (element) => element.userId == profile.userId, orElse: () {
          throw Exception('Reporter not found');
        });
        _selectedProfiles[index] = reporter;
      }
    });

    randomizeSecretWord();
    return _selectedProfiles;
  }

  List<GameProfile> _setReportersWithTwoPlayers(int sidekickIndex, Random rng) {
    final currentSideKick = _selectedProfiles[sidekickIndex];
    final reportersWithQuestions =
        _assignQuestionsToReporters([_selectedProfiles[sidekickIndex]], rng);
    _selectedProfiles[sidekickIndex] = currentSideKick.copyWith(
      roles: [...reportersWithQuestions[0].roles, ...currentSideKick.roles],
    );
    randomizeSecretWord();
    return _selectedProfiles;
  }

  List<GameProfile> _assignQuestionsToReporters(
      List<GameProfile> preReporters, Random rng) {
    final reportersWithQuestions = <GameProfile>[];

    final questions = _getAllQuestions();
    if (preReporters.length == 1) {
      final reporterQuestions = _pickQuestions(questions, 2, rng);
      reportersWithQuestions.add(
        preReporters[0]
            .copyWith(role: Role.reporter(questions: reporterQuestions)),
      );
    } else if (preReporters.length == 2) {
      final firstReporterQuestions = _pickQuestions(questions, 1, rng);
      final secondReporterQuestions = _pickQuestions(questions, 1, rng);
      reportersWithQuestions
        ..add(
          preReporters[0]
              .copyWith(role: Role.reporter(questions: firstReporterQuestions)),
        )
        ..add(
          preReporters[1].copyWith(
              role: Role.reporter(questions: secondReporterQuestions)),
        );
    } else {
      for (final reporter in preReporters) {
        if (reportersWithQuestions.length < 2) {
          final reporterQuestion = _pickQuestions(questions, 1, rng);
          reportersWithQuestions.add(
            reporter.copyWith(
              role: Role.reporter(questions: reporterQuestion),
            ),
          );
        } else {
          reportersWithQuestions.add(
            reporter.copyWith(
              role: const Role.reporter(questions: []),
            ),
          );
        }
      }
    }
    return reportersWithQuestions;
  }

  List<String> _pickQuestions(
    List<String> availableQuestions,
    int count,
    Random rng,
  ) {
    final selectedQuestions = <String>[];
    for (var i = 0; i < count; i++) {
      if (availableQuestions.isEmpty) {
        // ignore: parameter_assignments
        availableQuestions = _getAllQuestions();
      }
      final question =
          availableQuestions[rng.nextInt(availableQuestions.length)];
      selectedQuestions.add(question);
      availableQuestions.remove(question);
    }
    return selectedQuestions;
  }

  int _getCurrentSuperHeroIndex() {
    final index = _selectedProfiles.indexWhere((profile) {
      if (profile.role is SuperHero) {
        return true;
      }
      return false;
    });
    return index;
  }

  int _getCurrentSidekickIndex() {
    final index = _selectedProfiles.indexWhere((profile) {
      if (profile.roles.whereType<Sidekick>().isNotEmpty) {
        return true;
      }
      return false;
    });
    return index;
  }

  bool _isLastIndex(int superheroIndex) =>
      superheroIndex == _selectedProfiles.length - 1;

  // get currently playing family members with their possibly assigned roles
  List<GameProfile> getPlayers() {
    return _selectedProfiles;
  }

  String getCurrentSecretWord() {
    return _currentSecretWord!;
  }

  // call this to get a secret word or reroll it
  String randomizeSecretWord() {
    var list =
        _secretWords.where((word) => !_usedSecretWords.contains(word)).toList();
    if (list.isEmpty) {
      list = _secretWords;
      _usedSecretWords.clear();
    }
    final rng = Random();
    final wordIndex = rng.nextInt(list.length);
    _currentSecretWord = list[wordIndex];
    _usedSecretWords.add(list[wordIndex]);
    final superheroindex = _getCurrentSuperHeroIndex();
    final profile = _selectedProfiles[superheroindex];
    _selectedProfiles[superheroindex] =
        profile.copyWith(role: Role.superhero(secretWord: list[wordIndex]));
    return list[wordIndex];
  }

  final List<String> _secretWords = [
    'friends',
    'family',
    'fun',
    'food',
    'hug',
    'love',
    'pet',
    'smile',
    'games',
    'sun',
    'tree',
    'laugh',
    'toys',
    'school',
    'book',
    'music',
    'nature',
    'home',
    'share',
    'kindness',
    'play',
    'gift',
    'helper',
    'animal',
    'stars',
    'happy',
    'cute',
    'excited',
  ];

// get the questions that the reporters can ask
  List<String> _getAllQuestions() {
    return [
      'What made you smile today?',
      'Who is someone who helped you today?',
      'What’s something fun you did with a friend or family member today?',
      'What did you learn today that made you feel happy?',
      'What’s one thing you did today that made someone else happy?',
      'What’s something new you tried today?',
      'Who made you feel special today?',
      'What did you do today that made you feel brave?',
      'What’s something you saw today that made you feel happy?',
      'What’s one thing you did today to be kind to yourself?',
      'What’s something you’re looking forward to tomorrow?',
      'What did you see today that you thought was really cool or interesting?',
      'What’s one thing you’re really good at that you used today?',
      'Who is someone you’re thankful for today, and why?',
      'What’s something you did today that made you feel helpful?',
      'What made you laugh today?',
      'What’s one thing you’re thankful for at home?',
      'What’s something you enjoyed doing outside today?',
      'What’s something that made you feel loved today?',
    ];
  }

  GameProfile getCurrentSuperhero() =>
      _selectedProfiles[_getCurrentSuperHeroIndex()];

  GameProfile getCurrentSidekick() =>
      _selectedProfiles[_getCurrentSidekickIndex()];

  bool isFirstRound() => completedLoops == 0;

  bool isGameFinished() => completedLoops >= _selectedProfiles.length;

  List<String> getGuessOptions() {
    final options = <String>[];
    options.add(_currentSecretWord!);
    final rng = Random();
    while (options.length < 4) {
      final word = _secretWords[rng.nextInt(_secretWords.length)];
      if (!options.contains(word)) {
        options.add(word);
      }
    }
    options.shuffle();
    return options;
  }

  Future<GameStats> getGameStats() async {
    return _gameStatsData ??= await _fetchGameStats();
  }

  Future<GameStats> _fetchGameStats() async {
    final result = await _familyApiService.fetchGameStats();
    final stats = GameStats.fromJson(result);
    _gameStatsStreamController.add(stats);
    return stats;
  }
}
