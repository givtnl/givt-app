import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

class ReflectAndShareRepository {
  ReflectAndShareRepository(this._profilesRepository);

  final ProfilesRepository _profilesRepository;

  Future<List<GameProfile>> getFamilyProfiles() async {
    final profiles = await _profilesRepository.getProfiles();
    return profiles
        .map(
          (profile) => GameProfile(
            firstName: profile.firstName,
            lastName: profile.lastName,
            pictureURL: profile.pictureURL,
          ),
        )
        .toList();
  }

  List<GameProfile> getSelectedProfiles() {
    return [];
  }
}
