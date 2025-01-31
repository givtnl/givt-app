import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository.dart';
import 'package:givt_app/features/family/features/missions/presentation/models/missions_ui_model.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class MissionsCubit extends CommonCubit<MissionsUIModel, int> {
  MissionsCubit(this.repository) : super(const BaseState.loading());

  final MissionRepository repository;

  List<Mission>? _mission;

  Future<void> init({bool showTutorial = false}) async {
    // Show known data
    _mission = await repository.getMissions();
    _emitData();
    
    // At the same time also fetch new data
    _mission = await repository.getMissions(force: true);
    _emitData();

    if(showTutorial) {
      emitCustom(0);
    }
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
