import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class AnimatedSwitch extends StatelessWidget {
  const AnimatedSwitch({
    required this.pageIndex,
    required this.onChanged,
    super.key,
  });

  final int pageIndex;
  final dynamic Function(int)? onChanged;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return AnimatedToggleSwitch<int>.dual(
      current: pageIndex,
      first: 0,
      second: 1,
      height: 40,
      spacing: 1,
      indicatorSize: const Size.fromWidth(90),
      borderWidth: 1,
      style: const ToggleStyle(
        borderColor: AppTheme.givtNeutralGrey,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      animationCurve: Curves.easeInOut,
      indicatorTransition: const ForegroundIndicatorTransition.fading(),
      textMargin: EdgeInsets.zero,
      styleBuilder: (i) => i == pageIndex
          ? const ToggleStyle(backgroundColor: AppTheme.givtBlue)
          : const ToggleStyle(backgroundColor: Colors.white),
      iconBuilder: (value) => value == 0
          ? _buildToggleSwitch(
              0,
              text: locals.discoverSegmentNow,
            )
          : _buildToggleSwitch(
              1,
              text: locals.discoverSegmentWho,
            ),
      textBuilder: (value) => value == 1
          ? _buildToggleSwitch(0, text: locals.discoverSegmentNow)
          : _buildToggleSwitch(1, text: locals.discoverSegmentWho),
      onChanged: onChanged,
    );
  }

  Widget _buildToggleSwitch(
    int value, {
    required String text,
  }) =>
      ColoredBox(
        color: pageIndex == value ? AppTheme.givtBlue : Colors.white,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: pageIndex == value ? Colors.white : AppTheme.givtBlue,
            ),
          ),
        ),
      );
}
