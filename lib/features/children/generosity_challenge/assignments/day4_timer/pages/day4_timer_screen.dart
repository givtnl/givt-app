import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class Day4TimerScreen extends StatefulWidget {
  const Day4TimerScreen({super.key});

  @override
  State<Day4TimerScreen> createState() => _Day4TimerScreenState();
}

class _Day4TimerScreenState extends State<Day4TimerScreen> {
  _Day4TimerScreenState({int startSeconds = 5 * 60})
      : _remainingSeconds = startSeconds;

  Timer? _timer;

  int _remainingSeconds;

  String _displayMinutes() => (_remainingSeconds / 60).toInt().toString();

  String _displaySeconds() {
    final displaySeconds = _remainingSeconds % 60;
    return displaySeconds < 10 ? '0$displaySeconds' : displaySeconds.toString();
  }

  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);

    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Countdown Timer')),
      body: Center(
        child: Text(
          '${_displayMinutes()}:${_displaySeconds()}',
          style: TextStyle(fontSize: 48),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startCountdown,
        tooltip: 'Start Countdown',
        child: day4TimerIconGreen(),
      ),
    );
  }
}
