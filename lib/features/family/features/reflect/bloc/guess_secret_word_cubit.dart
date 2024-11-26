import 'dart:async';

import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
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
    'What word do you think you heard?',
    'Oops, try again',
    'Oh, so close',
    'Not quite, keep going',
  ];
  List<int> _pressedOptions = [];
  final String _successText = 'You did it, great job!';
  int _attempts = 0;
  bool _hasSuccess = false;
  late String _secretWord;
  late List<String> _guessOptions;

  void init() {
    _secretWord = _reflectAndShareRepository.getCurrentSecretWord();
    _guessOptions = _reflectAndShareRepository.getGuessOptions();
    _reflectAndShareRepository.completeLoop();
    _emitData();
  }

  Future<void> onClickOption(int index) async {
    _attempts++;
    _pressedOptions.add(index);
    if (_guessOptions[index].toLowerCase() == _secretWord.toLowerCase()) {
      _pressedOptions = [
        0,
        1,
        2,
        3,
      ]; // make sure people can't press wrong answers after pressing the correct answer
      emitCustom(const GuessTheWordCustom.showConfetti());
      // just to make sure we fire the analytics events once and save the stats once
      if (!_hasSuccess) {
        final kidsWithoutBedtime =
            await _reflectAndShareRepository.getKidsWithoutBedtime();
        // Check if it's the last game and delay for 2 seconds before continuing
        if (_reflectAndShareRepository.isGameFinished()) {
          unawaited(_reflectAndShareRepository.saveSummaryStats());
          Timer(const Duration(seconds: 2), () {
            if (kidsWithoutBedtime.isNotEmpty) {
              redirectToBedtimeSelection(kidsWithoutBedtime);
              return;
            }
            emitCustom(const GuessTheWordCustom.redirectToSummary());
          });
        }

        unawaited(AnalyticsHelper.logEvent(
          eventName:
              AmplitudeEvents.reflectAndShareGuessTotalAttemptsUntilCorrect,
          eventProperties: {
            'total': _attempts,
          },
        ));
      }
      _hasSuccess = true;
    }
    _emitData();
  }

  void redirectToBedtimeSelection(List<Profile> kidsWithoutBedtime) {
    emitCustom(
      GuessTheWordCustom.redirectToBedtimeSelection(
        kidsWithoutBedtime,
      ),
    );
    _emitData();
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.redirectedFromGratitudeGameToBedtimeSelection,
      eventProperties: {
        'total': _attempts,
      },
    );
  }

  void _emitData() {
    emitData(
      GuessTheWordUIModel(
        isGameFinished: _reflectAndShareRepository.isGameFinished(),
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
