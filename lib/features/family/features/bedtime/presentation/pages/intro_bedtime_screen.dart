import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:go_router/go_router.dart';

class IntroBedtimeScreen extends StatefulWidget {
  const IntroBedtimeScreen({super.key});

  @override
  State<IntroBedtimeScreen> createState() => _IntroBedtimeScreenState();
}

class _IntroBedtimeScreenState extends State<IntroBedtimeScreen>
    with TickerProviderStateMixin {
  late AnimationController _firstTextController;
  late AnimationController _secondTextController;
  late AnimationController _thirdTextController;
  late AnimationController _fourthTextController;
  late AnimationController _sunTransition;
  late AnimationController _nightShiftController;
  late AnimationController _moonTranition;

  late Animation<double> _firstTextOpacity;
  late Animation<double> _secondTextOpacity;
  late Animation<double> _thirdTextOpacity;
  late Animation<double> _fourthTextOpacity;
  late Animation<double> _sunScale;
  late Animation<double> _sunPostion;
  late Animation<double> _sunAwayPosition;
  late Animation<double> _cityDayPosition;
  late Animation<double> _cityNightOpacity;
  late Animation<Color?> _backgroundColor;
  late Animation<double> _moonPosition;

  bool _isNight = false;
  bool started = false;

  int tapCount = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationControllers
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

    _nightShiftController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _moonTranition = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Define the opacity animation
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
    // Define the scale animation for the sun
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
    _cityNightOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _nightShiftController,
        curve: Curves.easeIn,
      ),
    );

    _moonPosition = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(
        parent: _moonTranition,
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

    // Start the animation after a 1 second delay
    Future.delayed(const Duration(seconds: 1), () {
      _firstTextController.forward();
      setState(() {
        started = true;
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks
    _firstTextController.dispose();
    _sunTransition.dispose();
    _secondTextController.dispose();
    _thirdTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!started) return;
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
          _moonTranition.forward();
        }
        if (tapCount == 5) {
          context.pop();
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
              const SafeArea(child: GivtBackButtonFlat()),
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
                animation: _sunTransition,
                builder: (context, child) => cityAtBottom(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height,
                    _cityDayPosition.value,
                    1),
              ),
              AnimatedBuilder(
                animation: _moonTranition,
                builder: (context, child) => Padding(
                  padding: EdgeInsets.only(right: _moonPosition.value),
                  child: AnimatedBuilder(
                    animation: _nightShiftController,
                    builder: (context, child) => Opacity(
                        opacity: _cityNightOpacity.value,
                        child: sun(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height,
                          isNight: true,
                        )),
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
}
