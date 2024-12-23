import 'package:bloc/bloc.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';

class BackgroundAudioCubit extends Cubit<bool> {
  BackgroundAudioCubit(
    this._reflectAndShareRepository,
  ) : super(false);

  final ReflectAndShareRepository _reflectAndShareRepository;

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

  bool isFirstRound() {
    return _reflectAndShareRepository.isFirstRound();
  }
}
