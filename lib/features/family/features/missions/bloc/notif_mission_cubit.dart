import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/missions/presentation/models/notif_mission_ui_model.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationMissionsCubit
    extends CommonCubit<NotifMissionsUIModel, dynamic> {
  NotificationMissionsCubit(this.repository) : super(const BaseState.loading());

  final FamilyAuthRepository repository;

  void init() {
    _emitData(false);
  }

  Future<void> updateNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      _emitData(status.isGranted);
      await repository.updateNotificationId();
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
  }

  void _emitData(bool isGranted) {
    emitData(NotifMissionsUIModel(notifEnabled: isGranted));
  }
}
