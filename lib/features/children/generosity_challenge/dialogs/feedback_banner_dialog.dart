import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/models/task.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/givt_banner.dart';
import 'package:go_router/go_router.dart';

class FeedbackBannerDialog extends StatefulWidget {
  const FeedbackBannerDialog({
    required this.task,
    super.key,
  });

  final Task task;

  @override
  State<FeedbackBannerDialog> createState() => _FeedbackBannerDialogState();
}

class _FeedbackBannerDialogState extends State<FeedbackBannerDialog>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 600);
  static const Duration _showingBannerInitialDelay =
      Duration(milliseconds: 300);
  static const Duration _showingBannerDuration = Duration(milliseconds: 2000);
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
    await Future.delayed(_showingBannerInitialDelay, () {});
    await _controller.forward();
    await Future.delayed(_showingBannerDuration, () {});
    await _controller.reverse();
    if (mounted) {
      context.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _animateBanner();
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
            child: GivtBanner(
              badgeImage: widget.task.feedbackImage,
              title: widget.task.feedbackTitle,
              content: widget.task.feedbackContent,
            ),
          ),
        )
      ],
    );
  }
}
