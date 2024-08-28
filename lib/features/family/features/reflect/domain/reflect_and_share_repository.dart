import 'dart:math';

import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

class ReflectAndShareRepository {
  ReflectAndShareRepository(this._profilesRepository);

  final ProfilesRepository _profilesRepository;

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
    final superhero = rng.nextInt(allProfiles!.length);
    if(superhero == allProfiles!.length -1) {

    }
    //TODO
    return selectedProfiles;
  }

  List<GameProfile> getSelectedProfiles() {
    return [];
  }

  Future<List<String>> getQuestions() async {
    return ["what?", "how?", "when?"];
  }
}
