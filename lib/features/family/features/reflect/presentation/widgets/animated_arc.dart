import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/arc.dart';

class AnimatedArc extends StatefulWidget {
  final double diameter;
  final Color color;

  const AnimatedArc({
    super.key,
    required this.diameter,
    required this.color,
  });

  @override
  State<AnimatedArc> createState() => _AnimatedArcState();
}

class _AnimatedArcState extends State<AnimatedArc>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(const Duration(seconds: 1), () {
            _controller.forward();
          });
        }
      });

    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0.4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInQuad,
        reverseCurve: Curves.easeOutQuad,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Arc(
            diameter: widget.diameter,
            color: widget.color,
          ),
        );
      },
    );
  }
}
