import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/record_answer_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_dialog.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/record_timer.dart';
import 'package:givt_app/features/family/helpers/vibrator.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
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
  _RecordAnswerScreenState({int startSeconds = 60 * 2})
      : _remainingSeconds = startSeconds;
  Timer? _timer;
  int _remainingSeconds;
  InterviewCubit cubit = getIt<InterviewCubit>();
  AppConfig config = getIt<AppConfig>();
  bool isTestBtnVisible = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    isTestBtnVisible = config.isTestApp;
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
    cubit.onCountdownStarted();
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
      cubit.interviewFinished();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      appBar: FunTopAppBar.primary99(
        title: widget.uiModel.reporter.firstName!,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: SvgPicture.network(
            widget.uiModel.reporter.pictureURL!,
            width: 36,
            height: 36,
          ),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.xmark),
            onPressed: () {
              const LeaveGameDialog().show(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TitleMediumText(
              widget.uiModel.question,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
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
                    rightIcon: FontAwesomeIcons.arrowRight,
                    onTap: () {
                      if (_remainingSeconds == 60 * 2) {
                        _startCountdown();
                        setState(() {
                          isTestBtnVisible = false;
                        });
                        return;
                      }
                      cubit.advanceToNext();
                    },
                    text: widget.uiModel.buttonText,
                    analyticsEvent: AnalyticsEvent(
                      AmplitudeEvents.reflectAndShareNextJournalistClicked,
                    ),
                  ),
                ),
                Visibility(
                  visible: isTestBtnVisible,
                  child: const SizedBox(height: 8),
                ),
                Visibility(
                  visible: isTestBtnVisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FunButton(
                      onTap: () {
                        if (_remainingSeconds == 60 * 2) {
                          _startCountdown();
                          setState(() {
                            _remainingSeconds = 20;
                            isTestBtnVisible = false;
                          });
                          return;
                        }
                        cubit.advanceToNext();
                      },
                      text: 'Start test 20 seconds',
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.debugButtonClicked,
                      ),
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
    );
  }
}
