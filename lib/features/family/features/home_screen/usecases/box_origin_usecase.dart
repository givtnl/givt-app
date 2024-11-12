import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';

mixin class BoxOriginUseCase {
  final ImpactGroupsRepository _impactGroupsRepository =
      getIt<ImpactGroupsRepository>();

  Future<bool> setBoxOrigin(String churchId) async {
    try {
      return await _impactGroupsRepository.setBoxOrigin(churchId);
    } catch (e, s) {
      LoggingInfo.instance.error(
        'Error while setting organisation origin: $e',
        methodName: s.toString(),
      );
      return false;
    }
  }

  Future<void> setBoxOriginModalShown() async {
    await _impactGroupsRepository.setBoxOriginModalShown();
  }

  Future<bool> shouldShowBoxOriginModal() async {
    try {
      return (!await _impactGroupsRepository.wasBoxOriginModalShown()) &&
          await _impactGroupsRepository.getBoxOrigin() == null;
    } catch (e) {
      return false;
    }
  }
}
