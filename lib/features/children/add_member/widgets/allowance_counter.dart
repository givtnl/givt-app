import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/utils/utils.dart';

class AllowanceCounter extends StatefulWidget {
  const AllowanceCounter({
    required this.currency,
    this.initialAllowance,
    this.onAllowanceChanged,
    this.canAmountBeZero = false,
    super.key,
  });

  final String? currency;
  final int? initialAllowance;
  final void Function(int allowance)? onAllowanceChanged;
  final bool canAmountBeZero;

  @override
  State<AllowanceCounter> createState() => _AllowanceCounterState();
}

class _AllowanceCounterState extends State<AllowanceCounter> {
  static const int tapTime = 240;
  static const int holdDownDuration = 1000;
  static const int holdDownDuration2 = 2000;
  static const int maxAllowance = 999;
  static late int minAllowance;
  static const int allowanceIncrement = 5;
  static const int allowanceIncrement2 = 10;

  late int _allowance;
  Timer? _timer;
  Duration _heldDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    minAllowance = widget.canAmountBeZero ? 0 : 1;
    _allowance = widget.initialAllowance ?? 15;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer(void Function() callback) {
    _timer = Timer.periodic(const Duration(milliseconds: tapTime), (_) {
      _heldDuration += const Duration(milliseconds: tapTime);
      callback();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _heldDuration = Duration.zero;
  }

  void _incrementCounter() {
    final isHeldDurationShortEnoughForIncrement1 =
        (_heldDuration.inMilliseconds > holdDownDuration) &&
            _allowance >= maxAllowance - allowanceIncrement;
    final isHeldDurationShortEnoughForIncrement2 =
        (_heldDuration.inMilliseconds > holdDownDuration2) &&
            _allowance >= maxAllowance - allowanceIncrement2;

    if (_allowance >= maxAllowance ||
        isHeldDurationShortEnoughForIncrement1 ||
        isHeldDurationShortEnoughForIncrement2) {
      return;
    }
    setState(() {
      HapticFeedback.lightImpact();
      SystemSound.play(SystemSoundType.click);
      _allowance += (_heldDuration.inMilliseconds < holdDownDuration)
          ? 1
          : (_heldDuration.inMilliseconds < holdDownDuration2)
              ? allowanceIncrement
              : allowanceIncrement2;
    });
    widget.onAllowanceChanged?.call(_allowance);
  }

  void _decrementCounter() {
    final isHeldDurationLongEnoughForNegative1 =
        (_heldDuration.inMilliseconds > holdDownDuration) &&
            _allowance <= minAllowance + allowanceIncrement;
    final isHeldDurationLongEnoughForNegative2 =
        (_heldDuration.inMilliseconds > holdDownDuration2) &&
            _allowance <= minAllowance + allowanceIncrement2;

    if (_allowance <= minAllowance ||
        isHeldDurationLongEnoughForNegative1 ||
        isHeldDurationLongEnoughForNegative2) {
      return;
    }
    setState(() {
      HapticFeedback.lightImpact();
      SystemSound.play(SystemSoundType.click);
      _allowance -= (_heldDuration.inMilliseconds < holdDownDuration)
          ? 1
          : (_heldDuration.inMilliseconds < holdDownDuration2)
              ? allowanceIncrement
              : allowanceIncrement2;
    });
    widget.onAllowanceChanged?.call(_allowance);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTapDown: (_) {
            _startTimer(_decrementCounter);
          },
          onTapUp: (_) {
            _stopTimer();
          },
          onTapCancel: _stopTimer,
          onTap: (_allowance <= minAllowance) ? null : _decrementCounter,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              FontAwesomeIcons.circleMinus,
              size: 32,
              color: (_allowance < 2)
                  ? widget.canAmountBeZero
                      ? AppTheme.primary20
                      : Colors.grey
                  : AppTheme.primary20,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: _allowance < 100 ? 80 : 100,
          child: Text(
            '${widget.currency}$_allowance',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Rouna',
              fontWeight: FontWeight.w700,
              color: AppTheme.primary20,
              fontFeatures: <FontFeature>[FontFeature.liningFigures()],
            ),
          ),
        ),
        GestureDetector(
          onTapDown: (_) {
            _startTimer(_incrementCounter);
          },
          onTapUp: (_) {
            _stopTimer();
          },
          onTapCancel: _stopTimer,
          onTap: (_allowance > 998) ? null : _incrementCounter,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              FontAwesomeIcons.circlePlus,
              size: 32,
              color: (_allowance > 998) ? Colors.grey : AppTheme.primary20,
            ),
          ),
        ),
      ],
    );
  }
}
