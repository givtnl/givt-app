import 'dart:math';

import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';

class ReflectAndShareRepository {
  ReflectAndShareRepository(this._profilesRepository);

  final ProfilesRepository _profilesRepository;

  int completedLoops = 0;

  List<GameProfile>? _allProfiles;
  List<GameProfile> _selectedProfiles = [];
  String? _currentSecretWord;

  List<String> _usedSecretWords = [];

  List<GameProfile> getCurrentReporters() {
    //for quick prototyping/ development
    return [
      GameProfile(
        firstName: "Debbie",
        lastName: "Doe",
        pictureURL:
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero7.svg",
        type: "child",
        role: Role.reporter(questions: [
          "What is something kind that someone did for you today?",
        ]),
      ),
      GameProfile(
        firstName: "John",
        lastName: "Doe",
        pictureURL:
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero2.svg",
        type: "child",
        role: Role.reporter(questions: [
          "What is something you did today that you're proud of?",
        ]),
      ),
      GameProfile(
        firstName: "Kore",
        lastName: "Doe",
        pictureURL:
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero5.svg",
        type: "child",
        role: Role.reporter(questions: [
          "What is something you wish you could have done for someone else today?",
        ]),
      ),
      // GameProfile(
      //   firstName: "Jane",
      //   lastName: "Doe",
      //   pictureURL: "https://randomuser.me/api/portraits",
      //   type: "child",
      //   role: Role.reporter(questions: ["what is Gamora?", "why is Gamora?"]),
      // ),
      // GameProfile(
      //   firstName: "John",
      //   lastName: "Doe",
      //   pictureURL: "https://randomuser.me/api/portraits",
      //   type: "child",
      //   role: Role.reporter(questions: ["what is Gamora?", "why is Gamora?"]),
      // ),
    ];
    //TODO uncomment this if you want to do it based on the actual selection and randomisation
    return _selectedProfiles
        .where((profile) => profile.role is Reporter)
        .toList();
  }

  // complete a game loop/ round
  // return TRUE when all family members have been the superhero and the game should end, FALSE otherwhise
  bool completeLoop() {
    completedLoops++;
    return completedLoops == _allProfiles!.length;
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

    final questions = _getQuestions();
    final list = <GameProfile>[];
    _selectedProfiles.asMap().forEach((index, profile) {
      if (index == superheroIndex) {
        list.add(profile.copyWith(role: const Role.superhero()));
      } else if (index == sidekickIndex) {
        list.add(profile.copyWith(role: const Role.sidekick()));
      } else {
        var question = questions[rng.nextInt(questions.length)];
        list.add(profile.copyWith(role: Role.reporter(questions: [question])));
        questions.remove(question);
      }
    });
    _selectedProfiles = list;
    randomizeSecretWord();
    return list;
  }

  //
  List<GameProfile> assignRolesForNextRound() {
    final rng = Random();
    final superheroIndex = _getCurrentSuperHeroIndex();
    int newIndex;
    int sidekickIndex;
    if (_isLastIndex(superheroIndex)) {
      newIndex = 0;
      sidekickIndex = 1;
    } else {
      newIndex = superheroIndex + 1;
      if (_isLastIndex(newIndex)) {
        sidekickIndex = 0;
      } else {
        sidekickIndex = newIndex + 1;
      }
    }

    final questions = _getQuestions();
    final list = <GameProfile>[];
    _selectedProfiles.asMap().forEach((index, profile) {
      if (index == superheroIndex) {
        list.add(profile.copyWith(role: const Role.superhero()));
      } else if (index == sidekickIndex) {
        list.add(profile.copyWith(role: const Role.sidekick()));
      } else {
        var question = questions[rng.nextInt(questions.length)];
        list.add(profile.copyWith(role: Role.reporter(questions: [question])));
        questions.remove(question);
      }
    });
    _selectedProfiles = list;
    randomizeSecretWord();
    return _selectedProfiles;
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

  bool _isLastIndex(int superheroIndex) =>
      superheroIndex == _allProfiles!.length - 1;

  // get currently playing family members with their possibly assigned roles
  List<GameProfile> getPlayers() {
    return _selectedProfiles;
  }

  String getCurrentSecretWord() {
    return "test";
    final superheroindex = _getCurrentSuperHeroIndex();
    final profile = _selectedProfiles[superheroindex];
    return (profile as SuperHero).secretWord!;
  }

  // call this to get a secret word or reroll it
  String randomizeSecretWord() {
    final list =
        _secretWords.where((word) => !_usedSecretWords.contains(word)).toList();
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

  List<String> _secretWords = [
    "banana",
    "macarena",
    "shark",
    "hungry",
    "dance",
    "penguin",
    "sunset",
    "moon",
    "sun",
    "star",
    "planet",
    "earth",
  ];

// get the questions that the reporters can ask
  List<String> _getQuestions() {
    return [
      "What is something kind that someone did for you today?",
      "What is something you did today that you're proud of?",
      "What is something you wish you could have done for someone else today?",
    ];
  }
}
