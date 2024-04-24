import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class TripleAnimatedSwitch extends StatelessWidget {
  const TripleAnimatedSwitch({
    required this.pageIndex,
    required this.onChanged,
    super.key,
  });

  final int pageIndex;
  final dynamic Function(int)? onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<int>.size(
      textDirection: TextDirection.ltr,
      current: pageIndex,
      values: const [0, 1, 2],
      height: 40,
      dif: 1,
      iconOpacity: 1,
      innerColor: AppTheme.givtNeutralGrey,
      indicatorSize: const Size.fromWidth(90),
      iconBuilder: (int value, Size size) => switch (value) {
        0 => _buildToggleSwitch(context.l10n.discoverSegmentNow, 0),
        1 => _buildToggleSwitch(context.l10n.groups, 1),
        2 => _buildToggleSwitch(context.l10n.discoverSegmentWho, 2),
        _ => _buildToggleSwitch(context.l10n.give, 3),
      },
      borderWidth: 1,
      borderColor: AppTheme.givtNeutralGrey,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      animationCurve: Curves.easeInOut,
      colorBuilder: (i) => i == pageIndex ? AppTheme.givtBlue : Colors.white,
      onChanged: onChanged,
    );
  }

  Widget _buildToggleSwitch(
    String text,
    int value,
  ) =>
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
