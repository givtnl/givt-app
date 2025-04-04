import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/widgets/content/givt_banner.dart';
import 'package:givt_app/features/family/shared/widgets/content/tutorial/fun_tooltip.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class MissionCompletedBannerDialog extends StatefulWidget {
  const MissionCompletedBannerDialog({
    required this.missionName,
    this.showTooltip = false,
    super.key,
  });

  final String missionName;
  final bool showTooltip;

  @override
  State<MissionCompletedBannerDialog> createState() =>
      _MissionCompletedBannerDialogState();
}

class _MissionCompletedBannerDialogState
    extends State<MissionCompletedBannerDialog>
    with SingleTickerProviderStateMixin {
  final TooltipController _tooltipController = TooltipController();

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
    try {
      await Future<void>.delayed(_showingBannerInitialDelay);
      await _controller.forward();
      await Future<void>.delayed(_showingBannerDuration);
      await _controller.reverse();
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      // user already dismissed banner by swiping
    }
  }

  @override
  void initState() {
    if (widget.showTooltip == false) {
      _animateBanner();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return true == widget.showTooltip
        ? OverlayTooltipScaffold(
            startWhen: (instantiatedWidgetLength) async {
              return true == widget.showTooltip;
            },
            overlayColor: FamilyAppTheme.primary50.withOpacity(0.5),
            controller: _tooltipController,
            builder: (context) => _content(),
          )
        : Dismissible(
            key: const ValueKey('Reward-Banner'),
            onDismissed: (_) {
              _controller.stop();
              context.pop();
            },
            child: _content(),
          );
  }

  Stack _content() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: true == widget.showTooltip
              ? _tooltip()
              : SlideTransition(
                  position: _offsetAnimation,
                  child: _banner(),
                ),
        ),
      ],
    );
  }

  Widget _tooltip() {
    return FunTooltip(
      tooltipIndex: 0,
      title: 'Amazing work, superhero!',
      description:
          'I’ll let you take it from here. Head to your next mission and keep making a difference!',
      labelBottomLeft: '6/6',
      tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
      buttonIcon: const FaIcon(
        FontAwesomeIcons.check,
      ),
      analyticsEvent: AmplitudeEvents.tutorialDoneClicked,
      onButtonTap: () {
        _tooltipController.dismiss();
        _controller.stop();
        context.pop();
      },
      child: _banner(),
    );
  }

  GivtBanner _banner() {
    return GivtBanner(
      badgeImage: 'assets/family/images/reward_badge.svg',
      title: 'Completed',
      content: widget.missionName,
    );
  }
}
