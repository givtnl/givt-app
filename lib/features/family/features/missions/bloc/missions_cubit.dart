import 'package:givt_app/features/family/features/missions/presentation/models/missions_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';

class MissionsCubit extends CommonCubit<MissionsUIModel, dynamic> {
  MissionsCubit() : super(const BaseState.loading());

  final _todoMissions = <FunMissionCardUiModel>[
    FunMissionCardUiModel(
      title: 'Mission Bedtime',
      description: 'Make it a habit',
      progress: GoalProgressUimodel(amount: 50),
    ),
  ];
  final _completedMissions = <FunMissionCardUiModel>[
    FunMissionCardUiModel(
      title: 'Open the app',
      description: 'You did it!',
    ),
  ];

  void init() {
    _emitData();
  }

  void _emitData() {
    emitData(
      MissionsUIModel(
        todoMissions: _todoMissions,
        completedMissions: _completedMissions,
      ),
    );
  }
}
