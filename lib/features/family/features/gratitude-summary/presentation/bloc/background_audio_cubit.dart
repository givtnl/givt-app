import 'package:bloc/bloc.dart';

class BackgroundAudioCubit extends Cubit<bool> {
  BackgroundAudioCubit() : super(false);

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
}
