import 'package:givt_app/features/family/features/bedtime/presentation/models/mission_acceptance_custom.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/mission_acceptance_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class MissionAcceptanceCubit
    extends CommonCubit<MissionAcceptanceUIModel, MissionAcceptanceCustom> {
  MissionAcceptanceCubit() : super(const BaseState.initial());

  void init() {
    emitData(MissionAcceptanceUIModel(
      avatarBarUIModel: AvatarBarUIModel(
        avatarUIModels: [],
      ),
      familyName: 'Stokes',
    ));
  }
}
