import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/game_summary/data/game_summaries_repository.dart';
import 'package:givt_app/features/family/features/game_summary/data/models/game_summary_item.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/parent_summary_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GameSummariesCubit extends CommonCubit<List<GameSummaryItem>, dynamic> {
  GameSummariesCubit() : super(const BaseState.initial());
  final GameSummariesRepository _summaries = getIt<GameSummariesRepository>();
  final ProfilesRepository _profiles = getIt<ProfilesRepository>();
  List<GameSummaryItem> gameSummaries = [];
  List<Profile> profiles = [];
  Future<void> init() async {
    emitLoading();
    profiles = await _profiles.getProfiles();
    gameSummaries = await fetchGameSummaries();
    emitData(gameSummaries);
  }

  Future<List<GameSummaryItem>> fetchGameSummaries() async {
    try {
      final summaries = await _summaries.fetchGameSummaries(profiles);
      return summaries;
    } catch (e) {
      emitError(e.toString());
      LoggingInfo.instance.error('Error fetching game summaries: $e');
      return [];
    }
  }

  Future<SummaryUIModel> getSummaryUIModel(String id) async {
    emitLoading();

    try {
      final summary = await _summaries.fetchGameSummary(id);
      emitData(gameSummaries);
      return summary.toUIModel();
    } catch (e) {
      emitError(e.toString());
      LoggingInfo.instance.error('Error fetching game summary: $e');
      rethrow;
    }
  }
}
