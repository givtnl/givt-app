import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchCoinAnimatedWidget extends StatefulWidget {
  const SearchCoinAnimatedWidget({
    this.animationDuration = const Duration(milliseconds: 1000),
    super.key,
  });

  final Duration animationDuration;

  @override
  State<SearchCoinAnimatedWidget> createState() =>
      _SearchCoinAnimatedWidgetState();
}

class _SearchCoinAnimatedWidgetState extends State<SearchCoinAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: widget.animationDuration, vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedCoin(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedCoin extends AnimatedWidget {
  const AnimatedCoin({
    required Animation<double> animation,
    super.key,
    this.width = 120,
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
            bottom: -5,
            child: SvgPicture.asset(
                'assets/family/images/coin_searching_shadow.svg',),
          ),
          Positioned(
            child: Stack(
              children: [
                Opacity(
                  opacity: animation.value,
                  child: SvgPicture.asset(
                      'assets/family/images/search_coin_state_1.svg',),
                ),
                Opacity(
                  opacity: 1 - animation.value,
                  child: SvgPicture.asset(
                      'assets/family/images/search_coin_state_2.svg',),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
