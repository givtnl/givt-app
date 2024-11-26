import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/bedtime/blocs/mission_acceptance_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/actions/actions.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

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
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final AnimationController _secondAnimationController =
      AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  );
  late final AnimationController _enterAnimationController =
      AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  String buttonText = 'Hold to accept';
  bool holdDownAnimationCompleted = false;
  bool enterAnimationCompleted = false;

  @override
  void dispose() {
    _avatarsAnimationController.dispose();
    _textAnimationController.dispose();
    _fadeAnimationController.dispose();
    _secondAnimationController.dispose();
    _enterAnimationController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _cubit.init();
    _avatarsAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          holdDownAnimationCompleted = true;
        });
      }
    });
    print('before enter animation started');
    _enterAnimationController
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print('enter animation completed');
          setState(() {
            enterAnimationCompleted = true;
          });
        }
      })
      ..forward();
  }

  void _navigateToHome() {
    context.goNamed(FamilyPages.profileSelection.name);
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
        onInitial: (context) => Container(color: FamilyAppTheme.secondary10),
        onData: (context, uiModel) {
          return Stack(
            children: [
              if (!holdDownAnimationCompleted)
                Positioned(
                  left: 0,
                  top: 0,
                  child: FadeTransition(
                    opacity: _fadeAnimationController,
                    child: Image.asset(
                      'assets/family/images/moon.webp',
                    ),
                  ),
                ),
              if (!enterAnimationCompleted)
                poppingUpCityAtBottom(MediaQuery.sizeOf(context).width,
                    MediaQuery.sizeOf(context).height),
              if (enterAnimationCompleted)
                reactiveCityAtBottom(MediaQuery.sizeOf(context).width,
                    MediaQuery.sizeOf(context).height),
              if (holdDownAnimationCompleted)
                const Align(
                  child: TitleLargeText(
                    'Release the button!',
                    color: Colors.white,
                  ),
                ),
              if (!holdDownAnimationCompleted)
                PositionedTransition(
                  rect: RelativeRectTween(
                    begin: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * 0.3, 0, 0),
                    end: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * 0.9, 0, 0),
                  ).animate(
                    CurvedAnimation(
                      parent: _textAnimationController,
                      curve: Curves.easeInOutQuint,
                      reverseCurve: Curves.easeInOutQuint,
                    ),
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
              if (!holdDownAnimationCompleted)
                PositionedTransition(
                  rect: RelativeRectTween(
                    begin: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * 0.1, 0, 0),
                    end: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * 0.55, 0, 0),
                  ).animate(
                    CurvedAnimation(
                      parent: _avatarsAnimationController,
                      curve: Curves.easeInOutQuint,
                      reverseCurve: Curves.easeInOutQuint,
                    ),
                  ),
                  child: AvatarBar(
                    textColor: Colors.white,
                    uiModel: uiModel.avatarBarUIModel,
                    onAvatarTapped: (int index) {
                      //nothing
                    },
                  ),
                ),
              if (holdDownAnimationCompleted)
                PositionedTransition(
                  rect: RelativeRectTween(
                    begin: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * 0.55, 0, 0),
                    end: RelativeRect.fromLTRB(
                        0.5, MediaQuery.sizeOf(context).height * -1, 0, 0),
                  ).animate(
                    CurvedAnimation(
                        parent: _secondAnimationController,
                        curve: Curves.linear,
                        reverseCurve: Curves.linear),
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
                        .familyMissionAcceptanceScreenAcceptButtonPressed),
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

  // City at the bottom of the screen that pops up when we enter the screen
  Widget poppingUpCityAtBottom(double width, double height) {
    return PositionedTransition(
      rect: RelativeRectTween(
        end: RelativeRect.fromLTRB(0, 0, 0, -height + 231),
        begin: RelativeRect.fromLTRB(0, 0, 0, -height + (231 / 2)),
      ).animate(
        CurvedAnimation(
          parent: _enterAnimationController,
          curve: Curves.linear,
          reverseCurve: Curves.linear,
        ),
      ),
      child: _cityAsset(width),
    );
  }

  // City at the bottom of the screen that moves with the long press of the button
  Widget reactiveCityAtBottom(double width, double height) {
    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromLTRB(0, 0, 0, -height + 231),
        end: RelativeRect.fromLTRB(0, 0, 0, -height + (231 / 2)),
      ).animate(
        CurvedAnimation(
          parent: _avatarsAnimationController,
          curve: Curves.easeInOutQuint,
          reverseCurve: Curves.easeInOutQuint,
        ),
      ),
      child: _cityAsset(width),
    );
  }

  SizedBox _cityAsset(double width) {
    return SizedBox(
      height: 231,
      width: width,
      child: SvgPicture.asset(
        'assets/family/images/city_purple.svg',
        fit: BoxFit.fitWidth,
      ),
    );
  }

  void _playAnimation() {
    _avatarsAnimationController.forward();
    _textAnimationController.forward();
    _fadeAnimationController.reverse(from: 1);
  }

  void handleButtonReleased() {
    if (holdDownAnimationCompleted) {
      _secondAnimationController.forward();
      _navigateToHome();
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents
            .familyMissionAcceptanceScreenAcceptLongPressReleaseToAccept,
      );
    } else {
      _reverseAnimation();
    }
  }
}
