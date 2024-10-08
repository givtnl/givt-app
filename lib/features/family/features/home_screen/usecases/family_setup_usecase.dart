import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/cached_members/repositories/cached_members_repository.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';

mixin class FamilySetupUseCase {
  final CachedMembersRepository _cachedMembersRepository =
      getIt<CachedMembersRepository>();
  final ProfilesRepository _profilesRepository = getIt<ProfilesRepository>();

  Future<bool> hasNoFamilySetup() async {
    try {
      final profiles = await _profilesRepository.getProfiles();
      return profiles.length <= 1;
    } catch (e, s) {
      return false;
    }
  }

  Future<List<Member>> getCachedMembers() async {
    var cachedMembers = <Member>[];

    try {
      final members = await _cachedMembersRepository.loadFromCache();
      cachedMembers = members;
    } on Exception catch (e, s) {
      LoggingInfo.instance.error(
        'Error while fetching profiles: $e',
        methodName: s.toString(),
      );
    }
    return cachedMembers;
  }
}
