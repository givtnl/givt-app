import 'package:flutter/material.dart';

class CoinRaysAnimatedWidget extends StatefulWidget {
  const CoinRaysAnimatedWidget({
    this.animationDuration = const Duration(milliseconds: 10000),
    super.key,
  });

  final Duration animationDuration;

  @override
  State<CoinRaysAnimatedWidget> createState() => _CoinRaysAnimatedWidgetState();
}

class _CoinRaysAnimatedWidgetState extends State<CoinRaysAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat(reverse: false);

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedRays(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedRays extends AnimatedWidget {
  const AnimatedRays({
    super.key,
    required Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final animation = listenable as Animation<double>;
    return RotationTransition(
      turns: animation,
      child: Opacity(
        opacity: 0.4,
        child: Image.asset(
          'assets/family/images/coin_success_rays.png',
          height: mediaQuery.size.height,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
