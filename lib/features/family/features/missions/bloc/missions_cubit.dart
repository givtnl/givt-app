import 'package:givt_app/features/family/features/missions/presentation/models/missions_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MissionsCubit extends CommonCubit<MissionsUIModel, dynamic> {
  MissionsCubit() : super(const BaseState.loading());

  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    _emitData();
  }

  final _todoMissions = <FunMissionCardUIModel>[
    FunMissionCardUIModel(
      title: 'Mission Bedtime',
      description: 'Make it a habit',
      progress: GoalProgressUImodel(amount: 50),
    ),
  ];
  final _completedMissions = <FunMissionCardUIModel>[
    FunMissionCardUIModel(
      title: 'Open the app',
      description: 'You did it!',
    ),
  ];

  void _emitData() {
    emitData(
      MissionsUIModel(
        todoMissions: _todoMissions,
        completedMissions: _completedMissions,
      ),
    );
  }
}
