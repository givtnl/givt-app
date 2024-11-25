import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime_arguments.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/pages/setup_bedtime_screen.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/widgets/intro_bottom_city_widget.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/widgets/intro_new_moon_widget.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/widgets/intro_sun_widget.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:lottie/lottie.dart';

enum AnimationState {
  initial,
  started,
  shiftedToNight, //changes background to night, moves sun away revealing a moon, and changes city color
  newMoonWidgetIsOnScreen, // discards the previous sun & moon widgets and shows a new moon widget that can move as needed for this animation
  lastBenefitIsOnScreen,
}

enum TransitionObject {
  sun,
  night,
  moon,
  city,
}

class IntroBedtimeScreen extends StatefulWidget {
  const IntroBedtimeScreen({
    required this.arguments,
    super.key,
  });
  final BedtimeArguments arguments;
  @override
  State<IntroBedtimeScreen> createState() => _IntroBedtimeScreenState();
}

class _IntroBedtimeScreenState extends State<IntroBedtimeScreen>
    with TickerProviderStateMixin {
  List<AnimationController> _textTransitionControllers = [];
  List<AnimationController> _objectTransitionControllers = [];

  final List<String> _texts = [
    'Great job \nsuperheroes!',
    'Keep using your gratitude superpowers everyday',
    'We have found that the best time to play the Gratitude Game',
    'is in the evening before bedtime',
    'This reduces stress and anxiety',
    'Develops healthy relationships',
    'Helps sleep quality',
    'And ends the day on a positive note',
  ];

  late List<Animation<double>> _textOpacities;

  late Animation<double> _flareOpacity;
  late Animation<double> _sunScale;
  late Animation<double> _sunPostion;
  late Animation<double> _sunAwayPosition;
  late Animation<double> _cityDayPosition;
  late Animation<double> _cityDownPosition;
  late Animation<double> _cityNightOpacity;
  late Animation<Color?> _backgroundColor;
  late Animation<double> _newMoonPositionTop;
  late Animation<double> _newMoonPositionRight;
  late Animation<double> _newMoonOpacity;

  AnimationState _currentState = AnimationState.initial;
  int tapCount = 0;

  @override
  void initState() {
    super.initState();

    _textTransitionControllers = List.generate(8, (index) {
      var duration = 500;
      if (index == 0) {
        duration = 1000;
      }

      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: duration),
      );
    });

    _objectTransitionControllers = List.generate(4, (index) {
      return AnimationController(
        vsync: this,
      );
    });

    _objectTransitionControllers[TransitionObject.sun.index].duration =
        const Duration(milliseconds: 500);
    _objectTransitionControllers[TransitionObject.night.index].duration =
        const Duration(milliseconds: 800);
    _objectTransitionControllers[TransitionObject.city.index].duration =
        const Duration(milliseconds: 800);
    _objectTransitionControllers[TransitionObject.moon.index].duration =
        const Duration(milliseconds: 1000);

    _textOpacities = List.generate(_texts.length, (index) {
      return _createAnimation(
        _textTransitionControllers[index],
        Tween<double>(begin: 0, end: 1),
        Curves.easeInCubic,
      );
    });

    _initAnimations();
    _startInitialAnimation();
  }

  @override
  void dispose() {
    for (final controller in _textTransitionControllers) {
      controller.dispose();
    }
    
    for (final controller in _objectTransitionControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleNextState,
      child: Material(
        child: ColoredBox(
          color: FamilyAppTheme.secondary95,
          child: Stack(
            children: [
              AnimatedBuilder(
                builder: (context, child) => Container(
                  color: _backgroundColor.value,
                ),
                animation:
                    _objectTransitionControllers[TransitionObject.night.index],
              ),
              if (_currentState != AnimationState.newMoonWidgetIsOnScreen &&
                  _currentState != AnimationState.lastBenefitIsOnScreen)
                AnimatedBuilder(
                  builder: (context, child) => IntroSunWidget(
                    scale: _sunScale.value.clamp(0.5, 1),
                    position: _sunPostion.value,
                  ),
                  animation:
                      _objectTransitionControllers[TransitionObject.sun.index],
                ),
              for (int i = 0; i < _texts.length; i++)
                _buildText(
                  _texts[i],
                  _textOpacities[i],
                  color: i >= 3 ? Colors.white : null,
                ),
              if (_currentState == AnimationState.shiftedToNight)
                AnimatedBuilder(
                  animation: _objectTransitionControllers[
                      TransitionObject.night.index],
                  builder: (context, child) => IntroSunWidget(
                    position: _sunAwayPosition.value,
                  ),
                ),
              AnimatedBuilder(
                animation: _currentState == AnimationState.lastBenefitIsOnScreen
                    ? _objectTransitionControllers[TransitionObject.city.index]
                    : _objectTransitionControllers[TransitionObject.sun.index],
                builder: (context, child) => IntroBottomCityWidget(
                  position:
                      _currentState == AnimationState.lastBenefitIsOnScreen
                          ? _cityDownPosition.value
                          : _cityDayPosition.value,
                  opacity: 1,
                  nightShiftController: _objectTransitionControllers[
                      TransitionObject.night.index],
                  cityNightOpacity: _cityNightOpacity,
                ),
              ),
              if (_currentState != AnimationState.newMoonWidgetIsOnScreen &&
                  _currentState != AnimationState.lastBenefitIsOnScreen)
                AnimatedBuilder(
                  animation: _objectTransitionControllers[
                      TransitionObject.night.index],
                  builder: (context, child) => Opacity(
                    opacity: _cityNightOpacity.value,
                    child: const IntroSunWidget(
                      isNight: true,
                    ),
                  ),
                ),
              if (_currentState == AnimationState.newMoonWidgetIsOnScreen ||
                  _currentState == AnimationState.lastBenefitIsOnScreen)
                AnimatedBuilder(
                  animation: _textTransitionControllers[7],
                  builder: (context, child) => Opacity(
                    opacity: _newMoonOpacity.value.clamp(0, 1),
                    child: AnimatedBuilder(
                      animation: _objectTransitionControllers[
                          TransitionObject.moon.index],
                      builder: (context, child) => IntroNewMoonWidget(
                        positionTop: _newMoonPositionTop.value,
                        positionRight: _newMoonPositionRight.value,
                      ),
                    ),
                  ),
                ),
              if (_currentState == AnimationState.newMoonWidgetIsOnScreen ||
                  _currentState == AnimationState.lastBenefitIsOnScreen)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _objectTransitionControllers[
                        TransitionObject.moon.index],
                    builder: (context, child) => Opacity(
                      opacity: _flareOpacity.value,
                      child: Lottie.asset(
                        'assets/family/lotties/super_flare.json',
                        animate: _currentState ==
                            AnimationState.lastBenefitIsOnScreen,
                        repeat: false,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                        controller: _textTransitionControllers[7],
                      ),
                    ),
                  ),
                ),
              const SafeArea(child: GivtBackButtonFlat()),
              if (_currentState == AnimationState.lastBenefitIsOnScreen)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: FunButton(
                        onTap: () => Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                            ) =>
                                SetupBedtimeScreen(arguments: widget.arguments),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        ),
                        text: 'Continue',
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.introBedtimeAnimationContinuePressed,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _startInitialAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _textTransitionControllers[0].forward();
      setState(() {
        _currentState = AnimationState.started;
      });
    });
  }

  void _initAnimations() {
    _newMoonOpacity = _createAnimation(
      _textTransitionControllers[7],
      Tween<double>(begin: 1, end: 0),
      FamilyAppTheme.gentle,
    );
    _sunScale = _createAnimation(
      _objectTransitionControllers[TransitionObject.sun.index],
      Tween<double>(begin: 1, end: 0.5),
      FamilyAppTheme.gentle,
    );

    _sunPostion = _createAnimation(
      _objectTransitionControllers[TransitionObject.sun.index],
      Tween<double>(begin: 1, end: 0.2),
      Curves.easeIn,
    );

    _sunAwayPosition = _createAnimation(
      _objectTransitionControllers[TransitionObject.night.index],
      Tween<double>(begin: 0.2, end: 2.6),
      Curves.easeIn,
    );

    _cityDayPosition = _createAnimation(
      _objectTransitionControllers[TransitionObject.sun.index],
      Tween<double>(begin: 0.25, end: 0),
      Curves.easeIn,
    );
    _cityDownPosition = _createAnimation(
      _objectTransitionControllers[TransitionObject.city.index],
      Tween<double>(begin: 0, end: 0.125),
      FamilyAppTheme.gentle,
    );

    _cityNightOpacity = _createAnimation(
      _objectTransitionControllers[TransitionObject.night.index],
      Tween<double>(begin: 0, end: 1),
      Curves.easeIn,
    );
    _flareOpacity = _createAnimation(
      _objectTransitionControllers[TransitionObject.moon.index],
      Tween<double>(begin: 0, end: 1),
      Curves.easeIn,
    );

    _newMoonPositionTop = _createAnimation(
      _objectTransitionControllers[TransitionObject.moon.index],
      Tween<double>(begin: 0.2, end: 0),
      Curves.easeIn,
    );
    _newMoonPositionRight = _createAnimation(
      _objectTransitionControllers[TransitionObject.moon.index],
      Tween<double>(begin: 1, end: -0.8),
      Curves.easeIn,
    );

    _backgroundColor = _createAnimation(
      _objectTransitionControllers[TransitionObject.night.index],
      ColorTween(
        begin: FamilyAppTheme.secondary95,
        end: FamilyAppTheme.secondary10,
      ),
      Curves.easeIn,
    );
  }

  Animation<T> _createAnimation<T>(
    AnimationController controller,
    Tween<T> tween,
    Curve curve,
  ) {
    return tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  Widget _buildText(String text, Animation<double> opacity, {Color? color}) {
    return Center(
      child: FadeTransition(
        opacity: opacity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: HeadlineMediumText(
            text,
            textAlign: TextAlign.center,
            color: color,
          ),
        ),
      ),
    );
  }

  void _handleNextState() {
    if (_currentState == AnimationState.initial) return;
    tapCount++;
    switch (tapCount) {
      case 1:
        _startTextTransition(indexFrom: 0, indexTo: 1, ms: 500);
        _objectTransitionControllers[TransitionObject.sun.index].forward();
      case 2:
        _startTextTransition(indexFrom: 1, indexTo: 2, ms: 300);
      case 3:
        _startTextTransition(indexFrom: 2, indexTo: 3, ms: 300);
        _objectTransitionControllers[TransitionObject.night.index].forward();

        setState(() {
          _currentState = AnimationState.shiftedToNight;
        });
      case 4:
        _startTextTransition(indexFrom: 3, ms: 300);
        _objectTransitionControllers[TransitionObject.moon.index].forward();

        setState(() {
          _currentState = AnimationState.newMoonWidgetIsOnScreen;
        });
      case 5:
        _startTextTransition(indexTo: 4, ms: 300);
      case 6:
        _startTextTransition(indexFrom: 4, indexTo: 5, ms: 300);
      case 7:
        _startTextTransition(indexFrom: 5, indexTo: 6, ms: 300);
      case 8:
        _startTextTransition(indexFrom: 6, indexTo: 7, ms: 300);
        _objectTransitionControllers[TransitionObject.city.index].forward();

        setState(() {
          _currentState = AnimationState.lastBenefitIsOnScreen;
        });
      default:
        tapCount = 8;
        break;
    }
  }

  void _startTextTransition({
    required int ms,
    int? indexFrom,
    int? indexTo,
  }) {
    if (indexFrom != null) {
      _textTransitionControllers[indexFrom]
        ..duration = Duration(milliseconds: ms)
        ..reverse();
    }

    if (indexTo != null) {
      _textTransitionControllers[indexTo].forward();
    }
  }
}
