import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/day4_timer/widgets/how_many_tasks_widget.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/day4_timer/widgets/timer_widget.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/helpers/vibrator.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class Day4TimerScreen extends StatefulWidget {
  const Day4TimerScreen({super.key});

  @override
  State<Day4TimerScreen> createState() => _Day4TimerScreenState();
}

class _Day4TimerScreenState extends State<Day4TimerScreen> {
  _Day4TimerScreenState({int startSeconds = 5 * 60})
      : _remainingSeconds = startSeconds;

  final AppConfig _appConfig = getIt();
  final _player = AudioPlayer();
  Timer? _timer;

  int _remainingSeconds;
  bool _showHowManyTasksQuestion = false;

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

  bool _isLastSecond() => _lessThanAMinuteLeft() && _remainingSeconds % 60 <= 1;

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _logTimerEnded();
      } else {
        _handleEffects();
        setState(() {
          _remainingSeconds--;
        });
      }
    });
    _logTimerStarted();
  }

  void _handleEffects() {
    if (_isLastTenSeconds()) {
      Vibrator.tryVibrate();
      _playTickTockSound();
    } else {
      if (_isLastSecond()) {
        _playAlarmSound();
      } else {
        _playTickTockSound();
      }
    }
  }

  void _playAlarmSound() {
    _player
      ..setPlayerMode(PlayerMode.mediaPlayer)
      ..setReleaseMode(ReleaseMode.release)
      ..play(AssetSource('sounds/alarm2.wav'))
      ..onPlayerComplete.listen((event) {
        setState(() {
          _showHowManyTasksQuestion = true;
        });
      });
  }

  void _playTickTockSound() {
    _player.play(
      _remainingSeconds.isEven
          ? AssetSource('sounds/tick.wav')
          : AssetSource('sounds/tock.wav'),
    );
  }

  void _logTimerStarted() {
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.generosityChallengeDay4TimerStarted,
      ),
    );
  }

  void _logTimerEnded() {
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.generosityChallengeDay4TimerEnded,
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _player
      ..setPlayerMode(PlayerMode.lowLatency)
      ..setReleaseMode(ReleaseMode.stop);
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = context.watch<GenerosityChallengeCubit>();
    return BlocBuilder<GenerosityChallengeCubit, GenerosityChallengeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: FunTopAppBar.primary99(
            title: 'Day ${challenge.state.detailedDayIndex + 1}',
            leading: GenerosityBackButton(
              onPressed: () {
                challenge.overview();
                context.pop();
              },
            ),
          ),
          body: Center(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.generosityChallangeCardBorder,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: AppTheme.generosityChallangeCardBackground,
                  ),
                  child: _showHowManyTasksQuestion
                      ? HowManyTasksWidget(
                          onSubmitNrOfTasks: (tasks) {
                            challenge.confirmAssignment(
                              "$tasks ${tasks == 1 ? "task" : "tasks"} done. That's a nice number!",
                            );
                            context
                                .goNamed(FamilyPages.generosityChallenge.name);
                          },
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TimerWidget(
                              seconds: _displaySeconds(),
                              minutes: _displayMinutes(),
                              showRedVersion:
                                  _isLastTenSeconds() || _isLastSecond(),
                            ),
                            if (_appConfig.isTestApp)
                              FunButton(
                                onTap: () {
                                  setState(() {
                                    _remainingSeconds = 20;
                                  });
                                },
                                text: 'Debug: set to 20 seconds remaining',
                              ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
