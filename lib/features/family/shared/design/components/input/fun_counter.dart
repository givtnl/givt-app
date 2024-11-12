import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/buttons/custom_icon_border_button.dart';

class FunCounter extends StatefulWidget {
  const FunCounter({
    this.prefix = r'$',
    this.suffix = '',
    this.initialAmount,
    this.onAmountChanged,
    this.maxAmount,
    this.minAmount,
    this.canAmountBeZero = false,
    this.textColor,
    this.customIncrement = 1,
    super.key,
  });

  final String prefix;
  final String suffix;
  final int? initialAmount;
  final int? maxAmount;
  final int? minAmount;
  final void Function(int amount)? onAmountChanged;
  final bool canAmountBeZero;
  final int customIncrement;
  final Color? textColor;

  @override
  State<FunCounter> createState() => _FunCounterState();
}

class _FunCounterState extends State<FunCounter> {
  static const int tapTime = 240;
  static const int holdDownDuration = 1000;
  static const int holdDownDuration2 = 2000;
  static const int amountIncrement = 5;
  static const int amountIncrement2 = 10;
  int minAmount = 0;
  int maxAmount = 999;
  late int _currentAmount;
  Timer? _timer;
  Duration _heldDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    maxAmount = widget.maxAmount ?? maxAmount;
    _currentAmount = widget.initialAmount ?? 15;

    minAmount = widget.minAmount ?? (widget.canAmountBeZero == true ? 0 : 1);
    // If the min amount is less than 1 and the amount can't be zero, set it to 1
    if (!widget.canAmountBeZero && minAmount < 1) {
      minAmount = 1;
    }
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
          ? widget.customIncrement
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
          ? widget.customIncrement
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
      children: [
        CustomIconBorderButton(
          onTapDown: () {
            _startTimer(_decrementCounter);
          },
          onTapUp: _stopTimer,
          onTapCancel: _stopTimer,
          onTap: (_currentAmount <= minAmount) ? null : _decrementCounter,
          isMuted: true,
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.funCounterDecrementClicked,
          ),
          child: FaIcon(
            FontAwesomeIcons.minus,
            size: 25,
            color: (_currentAmount < 2)
                ? widget.canAmountBeZero && _currentAmount > 0
                    ? FamilyAppTheme.primary20
                    : Colors.grey
                : FamilyAppTheme.primary20,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: HeadlineLargeText(
            '${widget.prefix}$_currentAmount${widget.suffix}',
            textAlign: TextAlign.center,
            color: widget.textColor,
          ),
        ),
        CustomIconBorderButton(
          onTapDown: () {
            _startTimer(_incrementCounter);
          },
          onTapUp: _stopTimer,
          onTapCancel: _stopTimer,
          onTap: (_currentAmount > 998) ? null : _incrementCounter,
          isMuted: true,
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.funCounterIncrementClicked,
          ),
          child: FaIcon(
            FontAwesomeIcons.plus,
            size: 25,
            color:
                (_currentAmount > 998) ? Colors.grey : FamilyAppTheme.primary20,
          ),
        ),
      ],
    );
  }
}
