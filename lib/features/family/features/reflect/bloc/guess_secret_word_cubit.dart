import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GuessSecretWordCubit extends CommonCubit<String, dynamic> {
  GuessSecretWordCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {
    emitData(_reflectAndShareRepository.getCurrentSecretWord());
  }

  bool guessSecretWord(String guessedWord) {
    // Fetch word to compare
    final secretWord = _reflectAndShareRepository.getCurrentSecretWord();

    // Complete the loop
    _reflectAndShareRepository.completeLoop();
    
    // Check if the guessed word is correct
    return secretWord.toLowerCase() == guessedWord.toLowerCase();
  }
}
