import 'dart:math';

import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';

class ReflectAndShareRepository {
  ReflectAndShareRepository(this._profilesRepository);

  final ProfilesRepository _profilesRepository;

  // list to keep track if everyone has been the superhero yet
  List<int> superheroes = [];
  int completedLoops = 0;

  List<GameProfile>? allProfiles;
  List<GameProfile> selectedProfiles = [];

  // complete a game loop/ round
  // return TRUE when all family members have been the superhero and the game should end, FALSE otherwhise
  bool completeLoop() {
    completedLoops++;
    return completedLoops == allProfiles!.length;
  }

  // get all possibly family members that can play the game
  Future<List<GameProfile>> getFamilyProfiles() async {
    if (allProfiles != null) {
      return allProfiles!;
    }
    final profiles = await _profilesRepository.getProfiles();
    allProfiles = profiles
        .map(
          (profile) => GameProfile(
            firstName: profile.firstName,
            lastName: profile.lastName,
            pictureURL: profile.pictureURL,
          ),
        )
        .toList();
    return allProfiles!;
  }

  // select the family members that will participate in the game
  List<GameProfile> selectProfiles(List<int> selectedIndexes) {
    selectedProfiles = [];
    final map = allProfiles!.asMap();
    for (final index in selectedIndexes) {
      selectedProfiles.add(map[index]!);
    }
    return selectedProfiles;
  }

  // randomly assign roles to the selected family members (superhero, sidekick, reporter)
  List<GameProfile> randomlyAssignRoles() {
    final rng = Random();
    int sidekickIndex;
    final superheroIndex = rng.nextInt(allProfiles!.length);
    if (_isLastIndex(superheroIndex)) {
      sidekickIndex = 0;
    } else {
      sidekickIndex = superheroIndex + 1;
    }

    var questions = getQuestions();
    selectedProfiles.asMap().forEach((index, profile) {
      if (index == superheroIndex) {
        selectedProfiles[index] =
            profile.copyWith(role: Role.superhero(secretWord: getSecretWord()));
      } else if (index == sidekickIndex) {
        selectedProfiles[index] = profile.copyWith(role: const Role.sidekick());
      } else {
        var question = questions[rng.nextInt(questions.length)];
        selectedProfiles[index] =
            profile.copyWith(role: Role.reporter(questions: [question]));
        questions.remove(question);
      }
    });
    return selectedProfiles;
  }

  // get the secret word of the superhero to show under the scratch card
  String getSecretWord() {
    return "banana";
  }

  // reroll the secret word of the superhero to show under the scratch card
  String rerollSecretWord() {
    final GameProfile? profile = null;
    final index = selectedProfiles.indexWhere((profile) {
      if (profile.role is SuperHero) {
        profile = profile;
        return true;
      }
      return false;
    });

    selectedProfiles[index] =
        profile!.copyWith(role: Role.superhero(secretWord: "macarena"));
    return "macarena";
  }

  bool _isLastIndex(int superheroIndex) =>
      superheroIndex == allProfiles!.length - 1;

  // get currently playing family members with their possibly assigned roles
  List<GameProfile> getPlayers() {
    return [];
  }

  // get the questions that the reporters can ask
  List<String> getQuestions() {
    return [
      "what is Gamora?",
      "how is Gamora?",
      "when is Gamora?",
      "where is Gamora?",
      "who is Gamora?",
      "why is Gamora?",
      "what is a non-interesting fact about yourself?",
      "did you dance today?"
    ];
  }
}
