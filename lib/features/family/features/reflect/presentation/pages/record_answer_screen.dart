// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/day4_timer/widgets/timer_widget.dart';
import 'package:givt_app/features/family/helpers/vibrator.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';

class RecordAnswerScreen extends StatefulWidget {
  const RecordAnswerScreen({super.key});

  @override
  State<RecordAnswerScreen> createState() => _RecordAnswerScreenState();
}

class _RecordAnswerScreenState extends State<RecordAnswerScreen> {
  _RecordAnswerScreenState({int startSeconds = 30})
      : _remainingSeconds = startSeconds;
  Timer? _timer;
  int _remainingSeconds;

  String _displaySeconds() {
    final displaySeconds = _remainingSeconds;
    return displaySeconds < 10 ? '0$displaySeconds' : displaySeconds.toString();
  }

  bool _isLastFiveSeconds() =>
      _remainingSeconds % 60 <= 5 && _remainingSeconds % 60 > 1;

  bool _isLastSecond() => _remainingSeconds % 60 <= 1;

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
    if (_isLastFiveSeconds()) {
      Vibrator.tryVibrate();
    } else if (_isLastSecond()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FamilyScaffold(
      body: Column(
        children: [
          //text
          const Text('Record your answer'),
          // timer
          TimerWidget(
            seconds: _displaySeconds(),
            minutes: '00',
            showRedVersion: _isLastFiveSeconds(),
          ),
          // record button

          GivtElevatedButton(
            onTap: () {
              // start recording

              // start timer
              _startCountdown();
            },
            text: 'Record',
          )
        ],
      ),
    );
  }
}
