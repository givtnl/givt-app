import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/buttons/custom_icon_border_button.dart';

class FunCounter extends StatefulWidget {
  const FunCounter({
    required this.currency,
    this.initialAmount,
    this.onAmountChanged,
    this.maxAmount,
    this.canAmountBeZero = false,
    super.key,
  });

  final String? currency;
  final int? initialAmount;
  final int? maxAmount;
  final void Function(int amount)? onAmountChanged;
  final bool canAmountBeZero;

  @override
  State<FunCounter> createState() => _FunCounterState();
}

class _FunCounterState extends State<FunCounter> {
  static const int tapTime = 240;
  static const int holdDownDuration = 1000;
  static const int holdDownDuration2 = 2000;
  static const int amountIncrement = 5;
  static const int amountIncrement2 = 10;
  static late int minAmount;
  int maxAmount = 999;
  late int _currentAmount;
  Timer? _timer;
  Duration _heldDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    minAmount = widget.canAmountBeZero ? 0 : 1;
    maxAmount = widget.maxAmount ?? maxAmount;
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
          child: Text(
            '${widget.currency}$_currentAmount',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w700,
              color: FamilyAppTheme.secondary30,
              fontFeatures: <FontFeature>[
                const FontFeature.liningFigures(),
                const FontFeature.tabularFigures(),
              ],
            ),
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
