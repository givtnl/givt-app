import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinFound extends StatefulWidget {
  const CoinFound({
    super.key,
    this.initialWidth = 120,
    this.finalWidth = 200,
    this.animationDuration = const Duration(milliseconds: 700),
  });

  final double initialWidth;
  final double finalWidth;
  final Duration animationDuration;

  @override
  State<CoinFound> createState() => _CoinFoundedState();
}

class _CoinFoundedState extends State<CoinFound> {
  late double width;

  @override
  void initState() {
    super.initState();
    width = widget.initialWidth;
    Future.delayed(
      Duration.zero,
      () => setState(
        () {
          width = widget.finalWidth;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log('width: $width');
    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeOutBack,
      width: width,
      height: width,
      child: SvgPicture.asset('assets/family/images/coin_activated.svg'),
    );
  }
}
