import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_remote_config_platform_interface/src/remote_config_value.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/experience_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/gratitude_game_config.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/question_for_hero_model.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/features/remote_config/domain/remote_config_repository.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReflectAndShareRepository {
  ReflectAndShareRepository(
    this._profilesRepository,
    this._familyApiService,
    this._familyAuthRepository,
    this._remoteConfigRepository,
    this._createTransactionRepository,
    this._sharedPreferences,
  ) {
    _init();
  }

  final ProfilesRepository _profilesRepository;
  final FamilyAPIService _familyApiService;
  final FamilyAuthRepository _familyAuthRepository;
  final RemoteConfigRepository _remoteConfigRepository;
  final CreateTransactionRepository _createTransactionRepository;
  final SharedPreferences _sharedPreferences;

  static const String _gameConfigKey = 'gratitude_game_config';
  static const String _prefIsAiEnabledKey = 'pref_is_ai_enabled_key';

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
  final List<String> _currentSetOfQuestions = [];
  String? _currentSecretWord;
  bool _hasStartedInterview = false;
  bool _isAIEnabled = false;

  void setAIEnabled({required bool value}) {
    _isAIEnabled = value;
    _sharedPreferences.setBool(_prefIsAiEnabledKey, value);
  }

  GameStats? _gameStatsData;

  GratitudeGameConfig? _gameConfig;

  final StreamController<void> _gameFinishedStreamController =
      StreamController.broadcast();

  Stream<void> onFinishedAGame() => _gameFinishedStreamController.stream;

  int getAmountOfGenerousDeeds() => _generousDeeds;

  final StreamController<GameStats> _gameStatsUpdatedStreamController =
      StreamController.broadcast();

  Stream<GameStats> get onGameStatsUpdated =>
      _gameStatsUpdatedStreamController.stream;

  void _init() {
    _isAIEnabled = _sharedPreferences.getBool(_prefIsAiEnabledKey) ?? false;
    _createTransactionRepository.onTransactionByUser().listen((_) {
      _fetchGameStats();
    });
    _familyAuthRepository.authenticatedUserStream().listen((user) {
      if (user == null) {
        reset();
      }
    });
    _remoteConfigRepository
        .subscribeToRemoteConfigValue(_gameConfigKey)
        ?.listen(
          _handleGameConfigUpdated,
        );
  }

  bool isAiAllowed() {
    if (_gameConfig != null) {
      return _gameConfig!.isAiAllowed;
    }
    return false;
  }

  bool isAITurnedOn() {
    return _isAIEnabled && isAiAllowed();
  }

  void _handleGameConfigUpdated(RemoteConfigValue value) {
    try {
      final decodedBody = jsonDecode(value.asString()) as Map<String, dynamic>;
      _gameConfig = GratitudeGameConfig.fromJson(decodedBody);
    } catch (e, s) {
      // we could not decode the remote config value, no biggie as we have hardcoded values as back-up
      LoggingInfo.instance.logExceptionForDebug(
        e,
        stacktrace: s,
      );
    }
  }

  void incrementGenerousDeeds() {
    _generousDeeds++;
  }

  Future<ExperienceStats?> saveSummaryStats() async {
    try {
      _endTime = DateTime.now();
      totalTimeSpentInSeconds = _endTime!.difference(_startTime!).inSeconds;
      final map = await _familyApiService.saveGratitudeStats(
        totalTimeSpentInSeconds,
        _gameId,
      );
      return ExperienceStats.fromJson(map);
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
      return null;
    }
  }

  Future<QuestionForHeroModel> getQuestionForHero({
    String? audioPath,
    int questionNumber = 0,
  }) async {
    try {
      final currentHero = _selectedProfiles[_getCurrentSuperHeroIndex()];
      File? file;
      if (audioPath != null) {
        file = File(audioPath)..existsSync();
      }
      final response = await _familyApiService.getQuestionForHero(
        _gameId!,
        currentHero.userId,
        audioFile: file,
        questionNumber: questionNumber,
      );
      if (true == file?.existsSync()) {
        file?.deleteSync();
      }
      return QuestionForHeroModel.fromJson(response);
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
      return const QuestionForHeroModel();
    }
  }

  Future<void> shareHeroAudio(String path) async {
    try {
      final currentHero = _selectedProfiles[_getCurrentSuperHeroIndex()];
      final file = File(path);
      if (file.existsSync()) {
        await _familyApiService.uploadEndOfRoundHeroAudioFile(
          _gameId!,
          currentHero.userId,
          file,
        );
        await file.delete();
      }
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
  }

  Future<void> shareAudio(String path) async {
    try {
      final file = File(path);
      if (file.existsSync()) {
        await _familyApiService.uploadAudioFile(_gameId!, file);
        await file.delete();
      }
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
  }

  void saveGratitudeInterestsForCurrentSuperhero(TagCategory? gratitude) {
    _selectedProfiles[_getCurrentSuperHeroIndex()] =
        _selectedProfiles[_getCurrentSuperHeroIndex()]
            .copyWith(gratitude: gratitude);
  }

  TagCategory? getGratitudeInterestsForCurrentSuperhero() {
    return _selectedProfiles[_getCurrentSuperHeroIndex()].gratitude;
  }

  bool hasAnyGenerousPowerBeenSelected() {
    return _selectedProfiles.any((profile) => profile.power != null);
  }

  Future<void> saveGenerousPowerForCurrentSuperhero(TagCategory? power) async {
    _selectedProfiles[_getCurrentSuperHeroIndex()] =
        _selectedProfiles[_getCurrentSuperHeroIndex()].copyWith(
      power: power,
    );
    final gratitude = getGratitudeInterestsForCurrentSuperhero();

    try {
      await _familyApiService.saveUserGratitudeCategory(
        gameGuid: _gameId!,
        userid: _selectedProfiles[_getCurrentSuperHeroIndex()].userId,
        category: gratitude?.displayText ?? '',
        power: power?.title ?? '',
      );
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
  }

  TagCategory? getGenerousPowerForCurrentSuperhero() {
    return _selectedProfiles[_getCurrentSuperHeroIndex()].power;
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

  /// Retrieves the profiles of players who have participated in the game.
  Future<List<Profile>> getPlayerProfiles() async {
    final allProfiles = await _profilesRepository.getProfiles();
    final allPlayers = getPlayers();
    final profileMap = {for (var profil in allProfiles) profil.id: profil};
    final playerProfiles = allPlayers
        .map((player) => profileMap[player.userId])
        .whereType<Profile>()
        .toList();
    return playerProfiles;
  }

  void emptyAllProfiles() {
    _allProfiles = null;
  }

  String? getGameId() => _gameId;

  Future<void> createGameSession() async {
    try {
      _gameId = await _familyApiService.createGame(
        guids: _selectedProfiles.map((e) => e.userId).toList(),
      );
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
    reset();
    _selectedProfiles = selectedProfiles;
    createGameSession();
    _startTime = DateTime.now();
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

    final questions = getCurrentSetOfQuestions();
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
        availableQuestions = getCurrentSetOfQuestions();
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
    var list = getAllPossibleSecretWords()
        .where((word) => !_usedSecretWords.contains(word))
        .toList();
    if (list.isEmpty) {
      list = getAllPossibleSecretWords();
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

  // All possible secret words that can be used in the gratitude game
  List<String> getAllPossibleSecretWords() {
    if (_gameConfig?.isEmpty() == false) {
      return List.from(_gameConfig!.secretWords);
    } else {
      return _fallbackSecretWords;
    }
  }

  // fallback for when we cannot get the secret words from firebase remote config
  final List<String> _fallbackSecretWords = [
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

  // The questions we're using in this one particular instance of the game
  List<String> getCurrentSetOfQuestions() {
    if (_currentSetOfQuestions.isEmpty) {
      _currentSetOfQuestions.addAll(getAllPossibleQuestions());
    }
    return _currentSetOfQuestions;
  }

  // All possible questions that can be used in the gratitude game
  List<String> getAllPossibleQuestions() {
    if (_gameConfig?.isEmpty() == false) {
      return List.from(_gameConfig!.questions);
    } else {
      return _fallbackQuestions();
    }
  }

  // Fallback for when we cannot get the questions from firebase remote config
  List<String> _fallbackQuestions() {
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
      final word = getAllPossibleSecretWords()[
          rng.nextInt(getAllPossibleSecretWords().length)];
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

  /// Refreshes the game stats
  /// Returns true if the game stats were changed
  /// Returns false if the game stats were not changed
  Future<bool> refreshGameStats() async {
    final previousStats = _gameStatsData;
    await _fetchGameStats();
    return previousStats!.gratitudeGoal != _gameStatsData!.gratitudeGoal ||
        previousStats.gratitudeGoalCurrent !=
            _gameStatsData!.gratitudeGoalCurrent;
  }

  Future<GameStats> _fetchGameStats() async {
    final result = await _familyApiService.fetchGameStats();
    final stats = GameStats.fromJson(result);
    _gameStatsUpdatedStreamController.add(stats);
    _gameStatsData = stats;
    return stats;
  }

  void reset() {
    completedLoops = 0;
    totalQuestionsAsked = 0;
    _generousDeeds = 0;
    totalTimeSpentInSeconds = 0;
    _startTime = null;
    _endTime = null;
    _gameId = null;
    _allProfiles = null;
    _selectedProfiles = [];
    _currentSetOfQuestions.clear();
    _usedSecretWords.clear();
    _currentSecretWord = null;
    _hasStartedInterview = false;
  }

  void onCloseGame() {
    reset();
    _gameFinishedStreamController.add(null);
  }

  void onStartedInterview() {
    _hasStartedInterview = true;
  }

  bool hasStartedInterview() => _hasStartedInterview;

  Future<int> getTotalGamePlays() async =>
      _familyApiService.fetchTotalFamilyGameCount();

  /// The amount of games played by the user before we show the store review popup
  /// This is a (remotely) configurable value, by default it's 2
  int getStoreReviewMinimumGameCount() =>
      _gameConfig?.storeReviewGameCount ?? 2;

  /// The amount of games played by the user before we ask for an interview
  /// This is a (remotely) configurable value, by default it's 1
  int getInterviewMinimumGameCount() => _gameConfig?.interviewGameCount ?? 1;

  /// Whether or not to use the default interview icon
  /// for the popup that asks for an interview (default is comments, else its money-bill)
  bool useDefaultInterviewIcon() =>
      _gameConfig?.useDefaultInterviewIcon ?? true;

  String getAskForInterviewTitle() =>
      _gameConfig?.askForInterviewTitle ?? 'Earn \$50 for helping us!';

  String getAskForInterviewMessage() =>
      _gameConfig?.askForInterviewMessage ??
      'We’d love to hear your feedback about Givt on a quick call.';
}
