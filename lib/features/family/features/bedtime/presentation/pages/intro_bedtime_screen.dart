import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime_arguments.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/pages/setup_bedtime_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:lottie/lottie.dart';

class IntroBedtimeScreen extends StatefulWidget {
  const IntroBedtimeScreen({
    super.key,
    required this.arguments,
  });
  final BedtimeArguments arguments;
  @override
  State<IntroBedtimeScreen> createState() => _IntroBedtimeScreenState();
}

class _IntroBedtimeScreenState extends State<IntroBedtimeScreen>
    with TickerProviderStateMixin {
  late AnimationController _firstTextController;
  late AnimationController _secondTextController;
  late AnimationController _thirdTextController;
  late AnimationController _fourthTextController;
  late AnimationController _fifthTextController;
  late AnimationController _sixthTextController;
  late AnimationController _seventhTextController;
  late AnimationController _eigthTextController;
  late AnimationController _sunTransition;
  late AnimationController _nightShiftController;
  late AnimationController _moonTranitionToRight;
  late AnimationController _cityDownTransition;

  late Animation<double> _firstTextOpacity;
  late Animation<double> _secondTextOpacity;
  late Animation<double> _thirdTextOpacity;
  late Animation<double> _fourthTextOpacity;
  late Animation<double> _fifthTextOpacity;
  late Animation<double> _sixthTextOpacity;
  late Animation<double> _seventhTextOpacity;
  late Animation<double> _eigthTextOpacity;
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

  bool _isNight = false;
  bool _started = false;
  bool _newMoon = false;
  bool _revealSuperheroFlare = false;
  bool _animateSuperheroFlare = false;
  bool _isLast = false;

  int tapCount = 0;

  @override
  void initState() {
    super.initState();
    _firstTextController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _sunTransition = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _secondTextController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _thirdTextController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fourthTextController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fifthTextController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _sixthTextController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _seventhTextController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _eigthTextController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _nightShiftController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cityDownTransition = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _moonTranitionToRight = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _firstTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _firstTextController,
        curve: FamilyAppTheme.gentle,
      ),
    );
    _secondTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _secondTextController,
        curve: Curves.easeInCubic,
      ),
    );

    _thirdTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _thirdTextController,
        curve: Curves.easeInCubic,
      ),
    );
    _fourthTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fourthTextController,
        curve: Curves.easeInCubic,
      ),
    );
    _fifthTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fifthTextController,
        curve: Curves.easeInCubic,
      ),
    );
    _sixthTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _sixthTextController,
        curve: Curves.easeInCubic,
      ),
    );
    _seventhTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _seventhTextController,
        curve: Curves.easeInCubic,
      ),
    );
    _eigthTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _eigthTextController,
        curve: Curves.easeInCubic,
      ),
    );
    _newMoonOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _eigthTextController,
        curve: FamilyAppTheme.gentle,
      ),
    );
    _sunScale = Tween<double>(begin: 1, end: 0.5).animate(
      CurvedAnimation(
        parent: _sunTransition,
        curve: FamilyAppTheme.gentle,
      ),
    );

    _sunPostion = Tween<double>(begin: 1, end: 0.2).animate(
      CurvedAnimation(
        parent: _sunTransition,
        curve: Curves.easeIn,
      ),
    );

    _sunAwayPosition = Tween<double>(begin: 0.2, end: 2.6).animate(
      CurvedAnimation(
        parent: _nightShiftController,
        curve: Curves.easeIn,
      ),
    );

    _cityDayPosition = Tween<double>(begin: 0.25, end: 0).animate(
      CurvedAnimation(
        parent: _sunTransition,
        curve: Curves.easeIn,
      ),
    );
    _cityDownPosition = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(
        parent: _cityDownTransition,
        curve: FamilyAppTheme.gentle,
      ),
    );

    _cityNightOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _nightShiftController,
        curve: Curves.easeIn,
      ),
    );
    _flareOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _moonTranitionToRight,
        curve: Curves.easeIn,
      ),
    );

    _newMoonPositionTop = Tween<double>(begin: 0.2, end: 0).animate(
      CurvedAnimation(
        parent: _moonTranitionToRight,
        curve: Curves.easeIn,
      ),
    );
    _newMoonPositionRight = Tween<double>(begin: 1, end: -0.8).animate(
      CurvedAnimation(
        parent: _moonTranitionToRight,
        curve: Curves.easeIn,
      ),
    );

    _backgroundColor = ColorTween(
      begin: FamilyAppTheme.secondary95,
      end: FamilyAppTheme.secondary10,
    ).animate(
      CurvedAnimation(
        parent: _nightShiftController,
        curve: Curves.easeIn,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      _firstTextController.forward();
      setState(() {
        _started = true;
      });
    });
  }

  @override
  void dispose() {
    _firstTextController.dispose();
    _sunTransition.dispose();
    _secondTextController.dispose();
    _thirdTextController.dispose();
    _fourthTextController.dispose();
    _fifthTextController.dispose();
    _sixthTextController.dispose();
    _seventhTextController.dispose();
    _eigthTextController.dispose();
    _nightShiftController.dispose();
    _cityDownTransition.dispose();
    _moonTranitionToRight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_started) return;
        tapCount++;
        if (tapCount == 1) {
          _firstTextController
            ..duration = const Duration(milliseconds: 500)
            ..reverse();
          _secondTextController.forward();
          _sunTransition.forward();
        }
        if (tapCount == 2) {
          _secondTextController
            ..duration = const Duration(milliseconds: 300)
            ..reverse();
          _thirdTextController.forward();
        }
        if (tapCount == 3) {
          setState(() {
            _isNight = true;
          });
          _thirdTextController
            ..duration = const Duration(milliseconds: 300)
            ..reverse();
          _fourthTextController.forward();
          _nightShiftController.forward().then((value) {});
        }
        if (tapCount == 4) {
          _fourthTextController
            ..duration = const Duration(milliseconds: 300)
            ..reverse();
          setState(() {
            _newMoon = true;
            _revealSuperheroFlare = true;
          });
          _moonTranitionToRight.forward();
        }
        if (tapCount == 5) {
          _fifthTextController.forward();
        }
        if (tapCount == 6) {
          _fifthTextController
            ..duration = const Duration(milliseconds: 300)
            ..reverse();
          _sixthTextController.forward();
        }
        if (tapCount == 7) {
          _sixthTextController
            ..duration = const Duration(milliseconds: 300)
            ..reverse();
          _seventhTextController.forward();
        }
        if (tapCount == 8) {
          setState(() {
            _animateSuperheroFlare = true;
            _isLast = true;
          });
          _seventhTextController
            ..duration = const Duration(milliseconds: 300)
            ..reverse();
          _eigthTextController.forward();
          _cityDownTransition.forward();
        }
      },
      child: Material(
        child: ColoredBox(
          color: FamilyAppTheme.secondary95,
          child: Stack(
            children: [
              AnimatedBuilder(
                builder: (context, child) => Container(
                  color: _backgroundColor.value,
                ),
                animation: _nightShiftController,
              ),
              if (!_newMoon)
                AnimatedBuilder(
                  builder: (context, child) => sun(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height,
                    scale: _sunScale.value.clamp(0.5, 1),
                    position: _sunPostion.value,
                  ),
                  animation: _sunTransition,
                ),
              Center(
                child: FadeTransition(
                  opacity: _firstTextOpacity,
                  child: const HeadlineMediumText(
                    'Great job \nsuperheroes!',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _secondTextOpacity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: HeadlineMediumText(
                      'Keep using your gratitude superpowers everyday',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _thirdTextOpacity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: HeadlineMediumText(
                      'We have found that the best time to play the Gratitude Game',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _fourthTextOpacity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: HeadlineMediumText(
                      'is in the evening before bedtime',
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _fifthTextOpacity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: HeadlineMediumText(
                      'This reduces stress and anxiety',
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _sixthTextOpacity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: HeadlineMediumText(
                      'Develops healthy relationships',
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _seventhTextOpacity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: HeadlineMediumText(
                      'Helps sleep quality',
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _eigthTextOpacity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: HeadlineMediumText(
                      'And ends the day on a positive note',
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              if (_isNight)
                AnimatedBuilder(
                  animation: _nightShiftController,
                  builder: (context, child) => sun(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height,
                    position: _sunAwayPosition.value,
                  ),
                ),
              AnimatedBuilder(
                animation: _isLast ? _cityDownTransition : _sunTransition,
                builder: (context, child) => cityAtBottom(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                  _isLast ? _cityDownPosition.value : _cityDayPosition.value,
                  1,
                ),
              ),
              if (!_newMoon)
                AnimatedBuilder(
                  animation: _nightShiftController,
                  builder: (context, child) => Opacity(
                      opacity: _cityNightOpacity.value,
                      child: sun(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height,
                        isNight: true,
                      )),
                ),
              if (_newMoon)
                AnimatedBuilder(
                  animation: _eigthTextController,
                  builder: (context, child) => Opacity(
                    opacity: _newMoonOpacity.value.clamp(0, 1),
                    child: AnimatedBuilder(
                        animation: _moonTranitionToRight,
                        builder: (context, child) => newMoon(
                              MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height,
                              positionTop: _newMoonPositionTop.value,
                              positionRight: _newMoonPositionRight.value,
                            )),
                  ),
                ),
              if (_revealSuperheroFlare)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _moonTranitionToRight,
                    builder: (context, child) => Opacity(
                      opacity: _flareOpacity.value,
                      child: Lottie.asset(
                        'assets/family/lotties/super_flare.json',
                        animate: _animateSuperheroFlare,
                        repeat: false,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                        controller: _eigthTextController,
                      ),
                    ),
                  ),
                ),
              const SafeArea(child: GivtBackButtonFlat()),
              if (_isLast)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: FunButton(
                        onTap: () => Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                SetupBedtimeScreen(arguments: widget.arguments),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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

  Widget cityAtBottom(
      double width, double height, double position, double opacity) {
    return Stack(children: [
      Positioned(
        bottom: -height * position,
        child: AnimatedBuilder(
          animation: _nightShiftController,
          builder: (context, child) => Opacity(
            opacity: 1 - _cityNightOpacity.value,
            child: SizedBox(
              height: height * 0.25,
              width: width,
              child: SvgPicture.asset(
                'assets/family/images/city_day.svg',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: -height * position,
        child: AnimatedBuilder(
          animation: _nightShiftController,
          builder: (context, child) => Opacity(
            opacity: _cityNightOpacity.value,
            child: SizedBox(
              height: height * 0.25,
              width: width,
              child: SvgPicture.asset(
                'assets/family/images/city_purple.svg',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget sun(double width, double height,
      {double scale = 0.5, double position = 0.2, bool isNight = false}) {
    const smallestCircleModifier = 80;
    const middleCircleModifier = 40;

    return Padding(
      padding: EdgeInsets.only(top: ((height - width * scale) / 2) * position),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: width / 2 - width * scale / 2,
            child: Container(
              width: width * scale,
              height: width * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNight
                    ? const Color(0xFF1A2C3A)
                    : const Color(0xFFFFF9EB).withOpacity(0.7),
              ),
            ),
          ),
          Positioned(
            top: middleCircleModifier * scale,
            left: width / 2 - (width - middleCircleModifier * 2) * scale / 2,
            child: Container(
              width: (width - middleCircleModifier * 2) * scale,
              height: (width - middleCircleModifier * 2) * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNight
                    ? const Color(0xFF464D53)
                    : FamilyAppTheme.highlight95,
              ),
            ),
          ),
          Positioned(
            top: smallestCircleModifier * scale,
            left: width / 2 - (width - smallestCircleModifier * 2) * scale / 2,
            child: Container(
              width: (width - smallestCircleModifier * 2) * scale,
              height: (width - smallestCircleModifier * 2) * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNight
                    ? const Color(0xFFEAEAEA)
                    : FamilyAppTheme.highlight90,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget newMoon(
    double width,
    double height, {
    required double positionTop,
    required double positionRight,
  }) {
    const smallestCircleModifier = 80;
    const middleCircleModifier = 40;

    return Padding(
      padding: EdgeInsets.only(top: ((height - width * 0.5) / 2) * positionTop),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: (width - width * 0.5) / 2 * positionRight,
            child: Container(
              width: width * 0.5,
              height: width * 0.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1A2C3A),
              ),
            ),
          ),
          Positioned(
            top: middleCircleModifier * 0.5,
            left: width / 2 * positionRight -
                (width * positionRight - middleCircleModifier * 2) * 0.5 / 2,
            child: Container(
              width: (width - middleCircleModifier * 2) * 0.5,
              height: (width - middleCircleModifier * 2) * 0.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF464D53),
              ),
            ),
          ),
          Positioned(
            top: smallestCircleModifier * 0.5,
            left: (width * positionRight -
                    (width * positionRight - smallestCircleModifier * 2) *
                        0.5) /
                2,
            child: Container(
              width: (width - smallestCircleModifier * 2) * 0.5,
              height: (width - smallestCircleModifier * 2) * 0.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEAEAEA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
