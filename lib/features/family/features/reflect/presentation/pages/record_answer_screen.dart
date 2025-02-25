import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/record_cubit.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/fun_audio_waveform.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/interview_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/interview_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/record_timer.dart';
import 'package:givt_app/features/family/helpers/vibrator.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class RecordAnswerScreen extends StatefulWidget {
  const RecordAnswerScreen({required this.uiModel, super.key});

  final RecordAnswerUIModel uiModel;

  @override
  State<RecordAnswerScreen> createState() => _RecordAnswerScreenState();
}

class _RecordAnswerScreenState extends State<RecordAnswerScreen> {
  _RecordAnswerScreenState() : _remainingSeconds = startSeconds;

  static const int startSeconds = 60;

  Timer? _timer;
  int _remainingSeconds;
  InterviewCubit cubit = getIt<InterviewCubit>();
  final RecordCubit _recordCubit = getIt<RecordCubit>();
  AppConfig config = getIt<AppConfig>();

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _recordCubit.start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startCountdown();
  }

  String _displayMinutes() => (_remainingSeconds ~/ 60).toString();

  String _displaySeconds() {
    final displaySeconds = _remainingSeconds % 60;
    return displaySeconds < 10 ? '0$displaySeconds' : displaySeconds.toString();
  }

  bool _isLastTenSeconds() =>
      _lessThanAMinuteLeft() &&
      _remainingSeconds % 60 <= 10 &&
      _remainingSeconds % 60 > 1;

  bool _lessThanAMinuteLeft() => _remainingSeconds ~/ 60 == 0;

  bool _isLastSecond() => _remainingSeconds % 60 <= 1 && _remainingSeconds <= 1;

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
      } else {
        _handleEffects();

        if (!mounted) return;
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _handleEffects() {
    if (_isLastTenSeconds()) {
      Vibrator.tryVibrate();
    } else if (_isLastSecond()) {
      Vibrator.tryVibratePattern();
      cubit.timeForQuestionRanOut();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  void _resetTimer() {
    _remainingSeconds = startSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: cubit,
      listener: (BuildContext context, state) {
        if (state is CustomState && state.custom is ResetTimer) {
          _resetTimer();
        }
      },
      child: FunScaffold(
        canPop: false,
        appBar: FunTopAppBar(
          title: 'Question ${widget.uiModel.questionNumber}',
          actions: const [
            LeaveGameButton(),
          ],
        ),
        body: Column(
          children: [
            const Spacer(),
            const BodyMediumText(
              'Ask the superhero',
              textAlign: TextAlign.center,
            ),
            const FunAudioWaveform(),
            const SizedBox(height: 8),
            TitleMediumText(
              widget.uiModel.question,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.generosityChallangeCardBorder,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
                color: AppTheme.generosityChallangeCardBackground,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  RecordTimerWidget(
                    seconds: _displaySeconds(),
                    minutes: _displayMinutes(),
                    showRedVersion: _isLastTenSeconds(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FunButton(
                      onTap: () {
                        cubit.advanceToNext();
                      },
                      text: widget.uiModel.buttonText,
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.reflectAndShareNextJournalistClicked,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
