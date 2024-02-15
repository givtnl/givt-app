import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/cached_members/repositories/cached_members_repository.dart';

class CachedFamilyUtils {
  static bool isFamilyCacheExist() {
    final cachedMembersRepository = getIt<CachedMembersRepository>();
    return cachedMembersRepository.isCacheExist();
  }

  static Future<void> clearFamilyCache() async {
    final cachedMembersRepository = getIt<CachedMembersRepository>();
    await cachedMembersRepository.clearCache();
  }
}
