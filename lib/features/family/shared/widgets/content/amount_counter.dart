import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/utils/utils.dart';

class AmountCounter extends StatefulWidget {
  const AmountCounter({
    required this.currency,
    this.initialAmount,
    this.onAmountChanged,
    this.canAmountBeZero = false,
    super.key,
  });

  final String? currency;
  final int? initialAmount;
  final void Function(int amount)? onAmountChanged;
  final bool canAmountBeZero;

  @override
  State<AmountCounter> createState() => _AmountCounterState();
}

class _AmountCounterState extends State<AmountCounter> {
  static const int tapTime = 240;
  static const int holdDownDuration = 1000;
  static const int holdDownDuration2 = 2000;
  static const int maxAmount = 999;
  static late int minAmount;
  static const int amountIncrement = 5;
  static const int amountIncrement2 = 10;

  late int _currentAmount;
  Timer? _timer;
  Duration _heldDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    minAmount = widget.canAmountBeZero ? 0 : 1;
    _currentAmount = widget.initialAmount ?? 15;
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
            _currentAmount >= maxAmount - amountIncrement;
    final isHeldDurationShortEnoughForIncrement2 =
        (_heldDuration.inMilliseconds > holdDownDuration2) &&
            _currentAmount >= maxAmount - amountIncrement2;

    if (_currentAmount >= maxAmount ||
        isHeldDurationShortEnoughForIncrement1 ||
        isHeldDurationShortEnoughForIncrement2) {
      return;
    }
    setState(() {
      HapticFeedback.lightImpact();
      SystemSound.play(SystemSoundType.click);
      _currentAmount += (_heldDuration.inMilliseconds < holdDownDuration)
          ? 1
          : (_heldDuration.inMilliseconds < holdDownDuration2)
              ? amountIncrement
              : amountIncrement2;
    });
    widget.onAmountChanged?.call(_currentAmount);
  }

  void _decrementCounter() {
    final isHeldDurationLongEnoughForNegative1 =
        (_heldDuration.inMilliseconds > holdDownDuration) &&
            _currentAmount <= minAmount + amountIncrement;
    final isHeldDurationLongEnoughForNegative2 =
        (_heldDuration.inMilliseconds > holdDownDuration2) &&
            _currentAmount <= minAmount + amountIncrement2;

    if (_currentAmount <= minAmount ||
        isHeldDurationLongEnoughForNegative1 ||
        isHeldDurationLongEnoughForNegative2) {
      return;
    }
    setState(() {
      HapticFeedback.lightImpact();
      SystemSound.play(SystemSoundType.click);
      _currentAmount -= (_heldDuration.inMilliseconds < holdDownDuration)
          ? 1
          : (_heldDuration.inMilliseconds < holdDownDuration2)
              ? amountIncrement
              : amountIncrement2;
    });
    widget.onAmountChanged?.call(_currentAmount);
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
          onTap: (_currentAmount <= minAmount) ? null : _decrementCounter,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              FontAwesomeIcons.circleMinus,
              size: 32,
              color: (_currentAmount < 2)
                  ? widget.canAmountBeZero && _currentAmount > 0
                      ? AppTheme.primary20
                      : Colors.grey
                  : AppTheme.primary20,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: _currentAmount < 100 ? 80 : 100,
          child: Text(
            '${widget.currency}$_currentAmount',
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
          onTap: (_currentAmount > 998) ? null : _incrementCounter,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              FontAwesomeIcons.circlePlus,
              size: 32,
              color: (_currentAmount > 998) ? Colors.grey : AppTheme.primary20,
            ),
          ),
        ),
      ],
    );
  }
}
