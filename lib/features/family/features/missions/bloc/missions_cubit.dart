import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository.dart';
import 'package:givt_app/features/family/features/missions/presentation/models/missions_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';

class MissionsCubit extends CommonCubit<MissionsUIModel, dynamic> {
  MissionsCubit(this.repository) : super(const BaseState.loading());

  final MissionRepository repository;

  List<Mission>? _mission;

  Future<void> init() async {
    _mission = await repository.getMissions();
    _emitData();
  }

  final _todoMissions = <FunMissionCardUIModel>[
    FunMissionCardUIModel(
      title: 'Mission Bedtime',
      description: 'Make it a habit',
      progress: GoalProgressUImodel(amount: 0),
    ),
  ];
  final _completedMissions = <FunMissionCardUIModel>[
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
