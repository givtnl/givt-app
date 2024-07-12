import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/day4_timer/widgets/how_many_tasks_widget.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/day4_timer/widgets/timer_widget.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/helpers/vibrator.dart';
import 'package:givt_app/utils/app_theme.dart';

class Day4TimerScreen extends StatefulWidget {
  const Day4TimerScreen({super.key});

  @override
  State<Day4TimerScreen> createState() => _Day4TimerScreenState();
}

class _Day4TimerScreenState extends State<Day4TimerScreen> {
  _Day4TimerScreenState({int startSeconds = 20 ?? 5 * 60})
      : _remainingSeconds = startSeconds;

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
      } else {
        _handleEffects();
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _handleEffects() {
    if (_isLastTenSeconds()) {
      Vibrator.tryVibrate();
    } else {
      if (_isLastSecond()) {
        _flipStateAfterLastSound();
        _playAlarmSound();
      } else {
        _playTickTockSound();
      }
    }
  }

  void _flipStateAfterLastSound() {
    _player.onPlayerComplete.listen((event) {
      setState(() {
        _showHowManyTasksQuestion = true;
      });
    });
  }

  void _playAlarmSound() {
    _player.play(AssetSource('sounds/alarm2.wav'));
  }

  void _playTickTockSound() {
    _player.play(
      _remainingSeconds.isEven
          ? AssetSource('sounds/tick.wav')
          : AssetSource('sounds/tock.wav'),
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
          appBar: GenerosityAppBar(
            title: 'Day ${challenge.state.detailedDayIndex + 1}',
            leading: GenerosityBackButton(onPressed: challenge.overview),
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
                      ? const HowManyTasksWidget()
                      : TimerWidget(
                          seconds: _displaySeconds(),
                          minutes: _displayMinutes(),
                          showRedVersion:
                              _isLastTenSeconds() || _isLastSecond(),
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
