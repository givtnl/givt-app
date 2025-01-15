import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/missions/presentation/models/missions_ui_model.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class NotificationMissionsCubit extends CommonCubit<MissionsUIModel, dynamic> {
  NotificationMissionsCubit(this.repository) : super(const BaseState.loading());

  final FamilyAuthRepository repository;
  void updateNotificationPermission() {
    repository.updateNotificationId();
  }
}
