import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
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
      innerColor: const Color(0xFFDCDCE1),
      indicatorSize: const Size.fromWidth(90),
      iconBuilder: iconBuilder,
      borderWidth: 1,
      borderColor: const Color(0xFFDCDCE1),
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      animationCurve: Curves.easeInOut,
      colorBuilder: (i) => i == pageIndex ? AppTheme.givtBlue : Colors.white,
      onChanged: onChanged,
    );
  }

  Widget iconBuilder(int value, Size size) => switch (value) {
        0 => _buildToggleSwitch('Give', 0),
        1 => _buildToggleSwitch('Groups', 1),
        2 => _buildToggleSwitch('Discover', 2),
        _ => _buildToggleSwitch('Default', 3),
      };

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
