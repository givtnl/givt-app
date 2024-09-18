import 'dart:math';

import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';

class ReflectAndShareRepository {
  ReflectAndShareRepository(this._profilesRepository);

  final ProfilesRepository _profilesRepository;

  int completedLoops = 0;
  int totalQuestionsAsked = 0;
  int totalTimeSpent = 0;

  List<GameProfile>? _allProfiles;
  List<GameProfile> _selectedProfiles = [];
  String? _currentSecretWord;

  final List<String> _usedSecretWords = [];

  void saveGratitudeInterestsForCurrentSuperhero(List<Tag>? interests) {
    _selectedProfiles[_getCurrentSuperHeroIndex()] =
        _selectedProfiles[_getCurrentSuperHeroIndex()].copyWith(gratitudeInterests: interests);
  }

  List<GameProfile> getCurrentReporters() {
    return _selectedProfiles
        .where((profile) => profile.role is Reporter)
        .toList();
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

  // select the family members that will participate in the game
  void selectProfiles(List<GameProfile> selectedProfiles) {
    // Rest game state
    completedLoops = 0;
    totalQuestionsAsked = 0;
    totalTimeSpent = 0;

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
    final questions = _getAllQuestions();
    final list = <GameProfile>[];
    final reporters = <GameProfile>[];

    _selectedProfiles.asMap().forEach((index, profile) {
      if (index == superheroIndex) {
        list.add(profile.copyWith(role: const Role.superhero()));
      } else if (index == sidekickIndex) {
        list.add(profile.copyWith(role: const Role.sidekick()));
      } else {
        reporters.add(profile);
      }
    });

    if (reporters.length == 1) {
      final reporterQuestions = _pickQuestions(questions, 3, rng);
      list.add(
        reporters[0]
            .copyWith(role: Role.reporter(questions: reporterQuestions)),
      );
    } else if (reporters.length == 2) {
      final firstReporterQuestions = _pickQuestions(questions, 2, rng);
      final secondReporterQuestions = _pickQuestions(questions, 1, rng);
      list
        ..add(
          reporters[0]
              .copyWith(role: Role.reporter(questions: firstReporterQuestions)),
        )
        ..add(
          reporters[1].copyWith(
              role: Role.reporter(questions: secondReporterQuestions)),
        );
    } else {
      for (final reporter in reporters) {
        final reporterQuestion = _pickQuestions(questions, 1, rng);
        list.add(
          reporter.copyWith(
            role: Role.reporter(questions: reporterQuestion),
          ),
        );
      }
    }

    _selectedProfiles = list;
    randomizeSecretWord();
    return _selectedProfiles;
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
      if (profile.role is Sidekick) {
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
    'outside',
    'jump',
    'laugh',
    'adventure',
    'smile',
    'friendship',
    'brave',
    'home',
    'pizza',
    'banana',
    'shark',
    'hungry',
    'dance',
    'penguin',
    'sunset',
    'moon',
    'sun',
    'star',
    'planet',
    'earth',
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
}
