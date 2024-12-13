import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/bloc/background_audio_cubit.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

/*
  There's two ways to listen to the audio state of this widget.
  Either use a consumer to consume the events of the BackgroundAudioCubit
  or use the callback methods.
 */
class FunBackgroundAudioWidget extends StatefulWidget {
  const FunBackgroundAudioWidget({
    required this.audioPath,
    this.isVisible = false,
    this.onPlay,
    this.onPauseOrStop,
    super.key,
  });

  final bool isVisible;
  final String audioPath;
  final VoidCallback? onPlay;
  final VoidCallback? onPauseOrStop;

  @override
  State<FunBackgroundAudioWidget> createState() =>
      _FunBackgroundAudioWidgetState();
}

class _FunBackgroundAudioWidgetState extends State<FunBackgroundAudioWidget>
    with SingleTickerProviderStateMixin {

  final _audioPlayer = AudioPlayer();
  final BackgroundAudioCubit _cubit = getIt<BackgroundAudioCubit>();

  late AnimationController controller;

  final _iconsList = [
    FontAwesomeIcons.volumeOff,
    FontAwesomeIcons.volumeLow,
    FontAwesomeIcons.volumeHigh,
  ];

  final int _index = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
    _audioPlayer
      ..setReleaseMode(ReleaseMode.stop)
      ..onPlayerStateChanged.listen((event) {
        if (event == PlayerState.playing) {
          _cubit.onPlay();
          widget.onPlay?.call();
        } else {
          _cubit.onPauseOrStop();
          widget.onPauseOrStop?.call();
        }
      })
      ..play(AssetSource(widget.audioPath));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: FaIcon(
        _iconsList[_index],
        color: FamilyAppTheme.primary30,
      ),
    );
  }
}