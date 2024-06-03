import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/givt_banner.dart';
import 'package:go_router/go_router.dart';

class RewardBannerDialog extends StatefulWidget {
  const RewardBannerDialog({
    super.key,
  });

  @override
  State<RewardBannerDialog> createState() => _RewardBannerDialogState();
}

class _RewardBannerDialogState extends State<RewardBannerDialog>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 600);
  static const Duration _showingBannerInitialDelay =
      Duration(milliseconds: 300);
  static const Duration _showingBannerDuration = Duration(milliseconds: 3000);
  static const Curve _animationCurve = Curves.easeInOutBack;

  late final AnimationController _controller = AnimationController(
    duration: _animationDuration,
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, -2),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: _animationCurve,
    ),
  );

  Future<void> _animateBanner() async {
    await Future.delayed(_showingBannerInitialDelay);
    await _controller.forward();
    await Future.delayed(_showingBannerDuration);
    await _controller.reverse();
    if (mounted) {
      context.pop();
    }
  }

  @override
  void initState() {
    _animateBanner();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _offsetAnimation,
            child: const GivtBanner(
              badgeImage: 'assets/family/images/reward_badge.svg',
              title: 'New Reward',
              content: 'Avatar updated',
            ),
          ),
        ),
      ],
    );
  }
}
