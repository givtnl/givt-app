import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class FunAudioPlayer extends StatefulWidget {
  const FunAudioPlayer({
    required this.source,
    super.key,
    this.isUrl = false,
    this.showDeleteButton = true,
    this.onDelete,
  });

  final String source;
  final VoidCallback? onDelete;
  final bool isUrl;
  final bool showDeleteButton;

  @override
  FunAudioPlayerState createState() => FunAudioPlayerState();
}

class FunAudioPlayerState extends State<FunAudioPlayer> {
  double _controlSize = 50 + 28;
  static const double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
      await stop();
    });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
      (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
      (duration) => setState(() {
        _duration = duration;
      }),
    );

    _audioPlayer.setSource(_source);
    if (!widget.showDeleteButton) {
      _controlSize = _controlSize + 12;
    }
    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildControl(),
                _buildSlider(constraints.maxWidth),
                if (widget.showDeleteButton)
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: FamilyAppTheme.neutral70, size: _deleteBtnSize),
                    onPressed: () {
                      if (_audioPlayer.state == ap.PlayerState.playing) {
                        stop().then((value) {
                          _deleteFile();
                          widget.onDelete?.call();
                        });
                      } else {
                        _deleteFile();
                        widget.onDelete?.call();
                      }
                    },
                  ),
                if (!widget.showDeleteButton)
                  SizedBox(
                    width: 56,
                    child: BodyMediumText(
                      '${getMinutes()}:${getSeconds()}',
                      textAlign: TextAlign.right,
                      color: FamilyAppTheme.primary98,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  String getSeconds() {
    final seconds = _duration?.inSeconds ?? 0 % 60;
    return seconds < 10 ? '0$seconds' : '$seconds';
  }

  String getMinutes() {
    final minutes = _duration?.inMinutes ?? 0 % 60;
    return minutes < 10 ? '0$minutes' : '$minutes';
  }

  Widget _buildControl() {
    Widget icon;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const FunIcon(
        circleColor: FamilyAppTheme.error90,
        circleSize: 50,
        iconSize: 20,
        iconColor: FamilyAppTheme.error30,
        iconData: FontAwesomeIcons.pause,
        padding: EdgeInsets.fromLTRB(0, 14, 14, 14),
      );
    } else {
      icon = const FunIcon(
        circleSize: 50,
        iconSize: 20,
        iconColor: FamilyAppTheme.primary30,
        iconData: FontAwesomeIcons.play,
        padding: EdgeInsets.fromLTRB(0, 14, 14, 14),
      );
    }

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(60)),
      child: icon,
      onTap: () {
        if (_audioPlayer.state == ap.PlayerState.playing) {
          pause();
        } else {
          play();
        }
      },
    );
  }

  Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: FamilyAppTheme.primary60,
        inactiveColor: FamilyAppTheme.neutral90,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && position != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play() => _audioPlayer.play(_source);

  Future<void> pause() async {
    await _audioPlayer.pause();
    setState(() {});
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    setState(() {});
  }

  void _deleteFile() {
    final file = File(widget.source);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  Source get _source => widget.isUrl
      ? ap.UrlSource(widget.source)
      : ap.DeviceFileSource(widget.source);
}
