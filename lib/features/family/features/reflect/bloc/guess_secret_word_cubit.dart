import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/guess_option_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/guess_the_word_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/guess_the_word_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class GuessSecretWordCubit
    extends CommonCubit<GuessTheWordUIModel, GuessTheWordCustom> {
  GuessSecretWordCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;
  final List<String> _texts = [
    'Which one do you think it is?',
    'Oops, try again',
    'Oh, so close',
    'Not quite, keep going',
  ];
  final List<int> _pressedOptions = [];
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
    _pressedOptions.add(index);
    if (_guessOptions[index].toLowerCase() == _secretWord.toLowerCase()) {
      if (_hasSuccess) {
        AnalyticsHelper.logEvent(
          eventName:
              AmplitudeEvents.reflectAndShareGuessTotalAttemptsUntilCorrect,
          eventProperties: {
            'total': _attempts,
          },
        );
      }
      _hasSuccess = true;
      _reflectAndShareRepository.completeLoop();
      emitCustom(const GuessTheWordCustom.showConfetti());
    }
    _emitData();
  }

  void _emitData() {
    emitData(
      GuessTheWordUIModel(
        text: _hasSuccess ? _successText : _texts[_attempts],
        areContinuationButtonsEnabled: _hasSuccess,
        guessOptions: List.generate(
          _guessOptions.length,
          (index) => GuessOptionUIModel(
            text: _guessOptions[index],
            state: _pressedOptions.contains(index)
                ? _guessOptions[index].toLowerCase() ==
                        _secretWord.toLowerCase()
                    ? GuessOptionState.correct
                    : GuessOptionState.wrong
                : GuessOptionState.initial,
          ),
        ),
      ),
    );
  }
}
