import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';

mixin class BoxOrignUseCase {
  final ImpactGroupsRepository _impactGroupsRepository =
      getIt<ImpactGroupsRepository>();

  Future<bool> setBoxOrign(String churchId) async {
    try {
      return await _impactGroupsRepository.setBoxOrign(churchId);
    } catch (e, s) {
      LoggingInfo.instance.error(
        'Error while setting organisation origin: $e',
        methodName: s.toString(),
      );
      return false;
    }
  }

  Future<void> setBoxOrignModalShown() async {
    await _impactGroupsRepository.setBoxOrignModalShown();
  }

  Future<bool> shouldShowBoxOrignModal() async {
    try {
      return (!await _impactGroupsRepository.wasBoxOrignModalShown()) &&
          await _impactGroupsRepository.getBoxOrign() == null;
    } catch (e) {
      return false;
    }
  }
}
