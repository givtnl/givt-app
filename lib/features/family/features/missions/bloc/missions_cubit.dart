import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository.dart';
import 'package:givt_app/features/family/features/missions/presentation/models/missions_ui_model.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class MissionsCubit extends CommonCubit<MissionsUIModel, dynamic> {
  MissionsCubit(this.repository) : super(const BaseState.loading());

  final MissionRepository repository;

  List<Mission>? _mission;

  Future<void> init() async {
    _mission = await repository.getMissions();
    _emitData();
  }

  void _emitData() {
    if (_mission == null) {
      return;
    }

    emitData(
      MissionsUIModel(
        todoMissions: _mission!
            .where((m) => !m.isCompleted())
            .map((m) => m.toUIModel())
            .toList(),
        completedMissions: _mission!
            .where((m) => m.isCompleted())
            .map((m) => m.toUIModel())
            .toList(),
      ),
    );
  }
}
