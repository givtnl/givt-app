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
      dif: 10,
      height: 40,
      indicatorSize: const Size(100, double.infinity),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      innerColor: AppTheme.givtGraycece,
      borderColor: AppTheme.givtGraycece,
      indicatorColor: AppTheme.givtLightGreen,
      animationCurve: Curves.easeInOut,
      transitionType: ForegroundIndicatorTransitionType.fading,
      iconBuilder: (value) => value == 0
          ? _buildToggleSwitch(
              context,
              text: locals.discoverSegmentNow,
            )
          : _buildToggleSwitch(
              context,
              text: locals.discoverSegmentWho,
            ),
      textBuilder: (value) => value == 1
          ? _buildToggleSwitch(context, text: locals.discoverSegmentNow)
          : _buildToggleSwitch(context, text: locals.discoverSegmentWho),
      onChanged: onChanged,
    );
  }

  Center _buildToggleSwitch(
    BuildContext context, {
    required String text,
  }) =>
      Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
              ),
        ),
      );
}
