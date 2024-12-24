import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class AnimatedSpeaker extends StatefulWidget {
  const AnimatedSpeaker({super.key, bool pause = false, double height = 25})
      : _pause = pause,
        _height = height;
  factory AnimatedSpeaker.pause() {
    return const AnimatedSpeaker(pause: true);
  }
  final bool _pause;
  final double _height;
  @override
  State<AnimatedSpeaker> createState() => _AnimatedSpeakerState();
}

class _AnimatedSpeakerState extends State<AnimatedSpeaker>
    with SingleTickerProviderStateMixin {
  //using images not icons because there is no volume medium icon;
  late final List<String> _imagePaths = [
    'assets/family/images/background_player_1.svg',
    'assets/family/images/background_player_2.svg',
    'assets/family/images/background_player_3.svg',
  ];
  double _opacity1 = 0;
  double _opacity2 = 0;

  @override
  void initState() {
    super.initState();
    _startAnimationLoop();
  }

  Future<void> _startAnimationLoop() async {
    while (mounted && !widget._pause) {
      if (mounted) {
        setState(() {
          _opacity1 = 0;
          _opacity2 = 0;
        });
      }
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() => _opacity1 = 1.0);
      }
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() => _opacity2 = 1.0);
      }
      await Future<void>.delayed(const Duration(milliseconds: 600));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          _imagePaths[0],
          fit: BoxFit.fitHeight,
          height: widget._height,
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: _opacity1,
          curve: FamilyAppTheme.gentle,
          child: SvgPicture.asset(
            _imagePaths[1],
            fit: BoxFit.fitHeight,
            height: widget._height,
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: _opacity2,
          curve: FamilyAppTheme.gentle,
          child: SvgPicture.asset(
            _imagePaths[2],
            fit: BoxFit.fitHeight,
            height: widget._height,
          ),
        ),
      ],
    );
  }
}
