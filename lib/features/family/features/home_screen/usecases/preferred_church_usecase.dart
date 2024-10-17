import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';

mixin class PreferredChurchUseCase {
  final ImpactGroupsRepository _impactGroupsRepository =
      getIt<ImpactGroupsRepository>();

  Future<bool> setPreferredChurch(String churchId) async {
    try {
      return await _impactGroupsRepository.setPreferredChurch(churchId);
    } catch (e, s) {
      LoggingInfo.instance.error(
        'Error while setting preferred church: $e',
        methodName: s.toString(),
      );
      return false;
    }
  }

  Future<void> setPreferredChurchModalShown() async {
    await _impactGroupsRepository.setPreferredChurchModalShown();
  }

  Future<bool> shouldShowPreferredChurchModal() async {
    try {
      return (!await _impactGroupsRepository.wasPreferredChurchModalShown()) &&
          await _impactGroupsRepository.getPreferredChurch() == null;
    } catch (e, s) {
      return false;
    }
  }
}
