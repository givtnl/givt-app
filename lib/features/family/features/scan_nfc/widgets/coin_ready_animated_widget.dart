import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CoinReadyAnimatedWidget extends StatefulWidget {
  const CoinReadyAnimatedWidget({
    this.animationDuration = const Duration(milliseconds: 1000),
    super.key,
  });

  final Duration animationDuration;

  @override
  State<CoinReadyAnimatedWidget> createState() =>
      _CoinReadyAnimatedWidgetState();
}

class _CoinReadyAnimatedWidgetState extends State<CoinReadyAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: widget.animationDuration, vsync: this);
    animation = Tween<double>(begin: 1, end: 25).animate(controller)
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(
            const Duration(milliseconds: 200),
          );
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          await Future.delayed(
            const Duration(milliseconds: 100),
          );
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedCoinTap(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedCoinTap extends AnimatedWidget {
  const AnimatedCoinTap({
    super.key,
    this.width = 120,
    required Animation<double> animation,
  }) : super(listenable: animation);

  final double width;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return SizedBox(
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: 10,
            left: 12 + animation.value,
            child: SvgPicture.asset('assets/family/images/small_grey_coin.svg'),
          ),
          Positioned(
            child: SvgPicture.asset('assets/family/images/mobile.svg'),
          ),
        ],
      ),
    );
  }
}
