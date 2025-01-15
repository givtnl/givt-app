import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/missions/presentation/models/missions_ui_model.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class NotificationMissionsCubit extends CommonCubit<MissionsUIModel, dynamic> {
  NotificationMissionsCubit(this.repository) : super(const BaseState.loading());

  final FamilyAuthRepository repository;

  Future<void> updateNotificationPermission() async {
    try {
      await repository.updateNotificationId();
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
  }
}
