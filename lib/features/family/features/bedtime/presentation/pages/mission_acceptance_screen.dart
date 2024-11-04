import 'dart:io';

import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/navigation_bar_home_screen.dart';
import 'package:givt_app/features/family/shared/design/components/actions/actions.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:page_transition/page_transition.dart';

class MissionAcceptanceScreen extends StatefulWidget {
  const MissionAcceptanceScreen({super.key});

  @override
  State<MissionAcceptanceScreen> createState() =>
      _MissionAcceptanceScreenState();
}

class _MissionAcceptanceScreenState extends State<MissionAcceptanceScreen>
    with TickerProviderStateMixin {
  late final AnimationController _avatarsAnimationController =
      AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final AnimationController _textAnimationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final AnimationController _fadeAnimationController = AnimationController(
    value: 1,
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  String buttonText = 'Hold to accept';
  bool firstAnimationIsCompleted = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _avatarsAnimationController.addStatusListener((status) {
      /*final isAnimating = _controller.isAnimating;
      if (_isAnimating != isAnimating) {
        setState(() {
          _isAnimating = isAnimating;
        });
      }*/
      if (status == AnimationStatus.completed) {
        setState(() {
          firstAnimationIsCompleted = true;
        });

        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
        context,
        PageTransition<dynamic>(
            isIos: Platform.isIOS,
            type: PageTransitionType.bottomToTop,
            child: const NavigationBarHomeScreen()));
  }

  void _reverseAnimation() {
    _avatarsAnimationController.reverse();
    _textAnimationController.reverse();
    _fadeAnimationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /*Positioned.fill(
          child: Lottie.asset(
            repeat: false,
            'assets/lotties/hero_background_lottie.json',
            fit: BoxFit.fitWidth,
            // repeat: false,
            width: double.infinity,
          ),
        ),*/
        PositionedTransition(
          rect: RelativeRectTween(
            begin: RelativeRect.fromLTRB(
                0.5, MediaQuery.sizeOf(context).height * 0.4, 0, 0),
            end: RelativeRect.fromLTRB(
                0.5, MediaQuery.sizeOf(context).height * 0.9, 0, 0),
          ).animate(
            CurvedAnimation(
                parent: _textAnimationController,
                curve: Curves.linear,
                reverseCurve: Curves.elasticIn),
          ),
          child: FadeTransition(
            opacity: _fadeAnimationController,
            child: const TitleLargeText(
              'Is the Stokes Family ready to accept this mission of gratitude?',
              color: Colors.white,
            ),
          ),
        ),
        PositionedTransition(
          rect: RelativeRectTween(
            begin: RelativeRect.fromLTRB(
                0.5, MediaQuery.sizeOf(context).height * 0.5, 0, 0),
            end: RelativeRect.fromLTRB(
                0.5, MediaQuery.sizeOf(context).height * 0.9, 0, 0),
          ).animate(
            CurvedAnimation(
                parent: _avatarsAnimationController,
                curve: Curves.linear,
                reverseCurve: Curves.elasticIn),
          ),
          child: AvatarBar(
            textColor: Colors.white,
            uiModel: AvatarBarUIModel(avatarUIModels: [
              AvatarUIModel(
                avatarUrl:
                    'https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero4.svg',
                text: 'Test',
              ),
            ]),
            onAvatarTapped: (int index) {
              //nothing
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FunButton(
            text: 'Hold to accept',
            onTap: () {},
            onTapDown: () {
              _playAnimation();
            },
            onTapCancel: handleButtonReleased,
            onTapUp: handleButtonReleased,
            analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.coinMediumIdNotRecognizedGoBackHomeClicked),
          ),
        ),
      ],
    );
  }

  void _playAnimation() {
    _avatarsAnimationController.forward();
    _textAnimationController.forward();
    _fadeAnimationController.reverse(from: 1);
  }

  void handleButtonReleased() {
    if (firstAnimationIsCompleted) {
    } else {
      //TODO _reverseAnimation();
    }
  }
}
