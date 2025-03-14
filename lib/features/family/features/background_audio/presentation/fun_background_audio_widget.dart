import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/background_audio/bloc/background_audio_cubit.dart';
import 'package:givt_app/features/family/features/background_audio/presentation/animated_speaker.dart';
import 'package:givt_app/utils/analytics_helper.dart';

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
    this.iconColor,
    super.key,
  });

  final bool isVisible;
  final String audioPath;
  final Color? iconColor;
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
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    _audioPlayer
      ..setReleaseMode(ReleaseMode.stop)
      ..onPlayerStateChanged.listen((event) {
        if (event == PlayerState.playing) {
          if (mounted) {
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.audioWidgetPlayClicked,
            );
            setState(() => isPlaying = true);
            widget.onPlay?.call();
            _cubit.onPlay();
          }
        } else {
          if (mounted) {
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.audioWidgetPauseOrStopClicked,
            );
            setState(() => isPlaying = false);
            widget.onPauseOrStop?.call();
            _cubit.onPauseOrStop();
          }
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
      child: isPlaying
          ? AnimatedSpeaker(iconColor: widget.iconColor)
          : GestureDetector(
              onTap: () {
                _audioPlayer.play(AssetSource(widget.audioPath));
              },
              child: AnimatedSpeaker.pause(iconColor: widget.iconColor),
            ),
    );
  }
}
