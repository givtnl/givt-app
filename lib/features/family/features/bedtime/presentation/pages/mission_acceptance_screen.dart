import 'dart:io';

import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/bedtime/blocs/mission_acceptance_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/navigation_bar_home_screen.dart';
import 'package:givt_app/features/family/shared/design/components/actions/actions.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:page_transition/page_transition.dart';

class MissionAcceptanceScreen extends StatefulWidget {
  const MissionAcceptanceScreen({super.key});

  @override
  State<MissionAcceptanceScreen> createState() =>
      _MissionAcceptanceScreenState();
}

class _MissionAcceptanceScreenState extends State<MissionAcceptanceScreen>
    with TickerProviderStateMixin {
  final _cubit = getIt<MissionAcceptanceCubit>();
  late final AnimationController _avatarsAnimationController =
      AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  );
  late final AnimationController _textAnimationController = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  );
  late final AnimationController _fadeAnimationController = AnimationController(
    value: 1,
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );
  late final AnimationController _secondAnimationController =
      AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  );

  String buttonText = 'Hold to accept';
  bool firstAnimationIsCompleted = false;
  bool _isAnimating = false;

  @override
  void dispose() {
    _avatarsAnimationController.dispose();
    _textAnimationController.dispose();
    _fadeAnimationController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _cubit.init();
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

        //_reverseAnimation();
        // _navigateToHome();
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
    return SafeArea(
      child: BaseStateConsumer(
        cubit: _cubit,
        onInitial: (context) => Container(color: Colors.black),
        onData: (context, uiModel) {
          return Stack(
            children: [
              if (firstAnimationIsCompleted)
                const Align(
                  child: TitleLargeText(
                    'Release the button!',
                    color: Colors.white,
                  ),
                ),
              if (!firstAnimationIsCompleted)
                PositionedTransition(
                  rect: RelativeRectTween(
                    begin: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * 0.3, 0, 0),
                    end: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * 0.9, 0, 0),
                  ).animate(
                    CurvedAnimation(
                        parent: _textAnimationController,
                        curve: Curves.elasticIn,
                        reverseCurve: Curves.elasticIn),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimationController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TitleLargeText(
                        'Is the ${uiModel.familyName} Family ready to accept this mission of gratitude?',
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              if (!firstAnimationIsCompleted)
                PositionedTransition(
                  rect: RelativeRectTween(
                    begin: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * 0.1, 0, 0),
                    end: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * 0.55, 0, 0),
                  ).animate(
                    CurvedAnimation(
                        parent: _avatarsAnimationController,
                        curve: Curves.elasticIn,
                        reverseCurve: Curves.elasticIn),
                  ),
                  child: AvatarBar(
                    textColor: Colors.white,
                    uiModel: uiModel.avatarBarUIModel,
                    onAvatarTapped: (int index) {
                      //nothing
                    },
                  ),
                ),
              if (firstAnimationIsCompleted)
                PositionedTransition(
                  rect: RelativeRectTween(
                    begin: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * 0.55, 0, 0),
                    end: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * -1, 0, 0),
                  ).animate(
                    CurvedAnimation(
                        parent: _secondAnimationController,
                        curve: Curves.elasticIn,
                        reverseCurve: Curves.elasticIn),
                  ),
                  child: AvatarBar(
                    textColor: Colors.white,
                    uiModel: uiModel.avatarBarUIModel,
                    onAvatarTapped: (int index) {
                      //nothing
                    },
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FunButton(
                    text: 'Hold to accept',
                    onlyLongPress: true,
                    onLongPress: _playAnimation,
                    onLongPressUp: handleButtonReleased,
                    analyticsEvent: AnalyticsEvent(AmplitudeEvents
                        .coinMediumIdNotRecognizedGoBackHomeClicked),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _playAnimation() {
    _avatarsAnimationController.forward();
    _textAnimationController.forward();
    _fadeAnimationController.reverse(from: 1);
  }

  void handleButtonReleased() {
    if (firstAnimationIsCompleted) {
      _secondAnimationController.forward();
      _navigateToHome();
    } else {
      _reverseAnimation();
    }
  }
}
