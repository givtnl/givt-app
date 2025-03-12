import 'package:bloc/bloc.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/models/parent_summary_item.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/repositories/parent_summary_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';

class BackgroundAudioCubit extends Cubit<bool> {
  BackgroundAudioCubit(
    this._reflectAndShareRepository,
    this._summaryRepository,
  ) : super(false);

  final ReflectAndShareRepository _reflectAndShareRepository;
  final ParentSummaryRepository _summaryRepository;
  ParentSummaryItem? lastGame;

  void onPlay() {
    emit(true);
  }

  void onPauseOrStop() {
    emit(false);
  }

  @override
  Future<void> close() async {
    emit(false);
    return super.close();
  }

  Future<bool> isFirstRoundofFirstGame() async {
    final isFirstRound = _reflectAndShareRepository.isFirstRound();
    if (!isFirstRound) return false;

    return isFirstGame();
  }

  Future<bool> isFirstGame() async {
    final gamePlays = await _reflectAndShareRepository.getTotalGamePlays();
    if (gamePlays == 0) return true;

    return false;
  }
}
