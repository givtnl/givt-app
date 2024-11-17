import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class BedtimeSunAnimation extends StatefulWidget {
  const BedtimeSunAnimation({super.key});

  @override
  State<BedtimeSunAnimation> createState() => _BedtimeSunAnimationState();
}

class _BedtimeSunAnimationState extends State<BedtimeSunAnimation>
    with TickerProviderStateMixin {
  late AnimationController _sunAnimationController;

  late Animation<double> _sunScale;
  late Animation<double> _sunPostion;
  @override
  void initState() {
    super.initState();
    _sunAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Define the scale animation for the sun
    _sunScale = Tween<double>(begin: 1, end: 0.5).animate(
      CurvedAnimation(
        parent: _sunAnimationController,
        curve: FamilyAppTheme.gentle,
      ),
    );

    _sunPostion = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _sunAnimationController,
        curve: FamilyAppTheme.gentle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
