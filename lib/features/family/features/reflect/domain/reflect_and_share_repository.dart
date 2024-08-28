import 'dart:math';

import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';

class ReflectAndShareRepository {
  ReflectAndShareRepository(this._profilesRepository);

  final ProfilesRepository _profilesRepository;

  // list to keep track if everyone has been the superhero yet
  List<int> superheroes = [];

  List<GameProfile>? allProfiles;
  List<GameProfile> selectedProfiles = [];

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

  List<GameProfile> selectProfiles(List<int> selectedIndexes) {
    selectedProfiles = [];
    final map = allProfiles!.asMap();
    for (final index in selectedIndexes) {
      selectedProfiles.add(map[index]!);
    }
    return selectedProfiles;
  }

  List<GameProfile> randomlyAssignRoles() {
    final rng = Random();
    var sidekickIndex;
    final superheroIndex = rng.nextInt(allProfiles!.length);
    if (_isLastIndex(superheroIndex)) {
      sidekickIndex = 0;
    } else {
      sidekickIndex = superheroIndex + 1;
    }

    final questions = getQuestions();
    selectedProfiles.asMap().forEach((index, profile) {
      if (index == superheroIndex) {
        selectedProfiles[index] =
            profile.copyWith(role: Role.superhero(secretWord: getSecretWord()));
      } else if (index == sidekickIndex) {
        selectedProfiles[index] = profile.copyWith(role: const Role.sidekick());
      } else {
        selectedProfiles[index] = profile.copyWith(
            role: Role.reporter(questions: [questions[index]]));
      }
    });
    final amountReporters = selectedProfiles.length - 2;
    return selectedProfiles;
  }

  String getSecretWord() {
    return "banana";
  }

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

  List<GameProfile> getSelectedProfiles() {
    return [];
  }

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
