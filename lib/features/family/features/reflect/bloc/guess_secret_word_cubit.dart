import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/guess_the_word_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GuessSecretWordCubit extends CommonCubit<GuessTheWordUIModel, dynamic> {
  GuessSecretWordCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;
  final List<String> _texts = [
    'Which one do you think it is?',
    'Oops, try again',
    'Oh, so close',
    'Not quite, keep going',
  ];
  final String _successText = 'You did it, great job!';
  int _attempts = 0;
  bool _hasSuccess = false;
  late String _secretWord;
  late List<String> _guessOptions;

  void init() {
    _secretWord = _reflectAndShareRepository.getCurrentSecretWord();
    _guessOptions = _reflectAndShareRepository.getGuessOptions();
    _emitData();
  }

  void onClickOption(int index) {
    _attempts++;
    if (_guessOptions[index].toLowerCase() == _secretWord.toLowerCase()) {
      _hasSuccess = true;
      _reflectAndShareRepository.completeLoop();
      //emitcustom confetti
    }
    _emitData();
  }

  void _emitData() {
    emitData(
      GuessTheWordUIModel(
        text: _hasSuccess ? _successText : _texts[_attempts],
        areContinuationButtonsEnabled: _hasSuccess,
      ),
    );
  }
}
