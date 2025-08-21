import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/features/gratitude-summary/data/record_utils.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:record/record.dart';

class FunAudioRecorder extends StatefulWidget {
  const FunAudioRecorder({required this.onStop, super.key});

  final void Function(String path) onStop;

  @override
  State<FunAudioRecorder> createState() => _FunAudioRecorderState();
}

class _FunAudioRecorderState extends State<FunAudioRecorder>
    with AudioRecorderMixin {
  int _recordDuration = 0;
  Timer? _timer;
  late final AudioRecorder _audioRecorder;
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;

  // ignore: unused_field
  late Amplitude? _amplitude;

  @override
  void initState() {
    _audioRecorder = AudioRecorder();

    _recordSub = _audioRecorder.onStateChanged().listen(_updateRecordState);

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
      setState(() => _amplitude = amp);
    });

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        const encoder = AudioEncoder.aacLc;

        if (!await _isEncoderSupported(encoder)) {
          return;
        }

        final devs = await _audioRecorder.listInputDevices();
        debugPrint(devs.toString());

        const config = RecordConfig(numChannels: 1);

        // Record to file
        await recordFile(_audioRecorder, config);

        // Record to stream
        // await recordStream(_audioRecorder, config);

        _recordDuration = 0;

        _startTimer();

        await AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.audioRecordingStarted,
        );
      }
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    }
  }

  Future<void> _stop() async {
    final path = await _audioRecorder.stop();

    await AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.audioRecordingStopped,
    );

    if (path != null) {
      widget.onStop(path);
    }
  }

  void _updateRecordState(RecordState recordState) {
    setState(() => _recordState = recordState);

    switch (recordState) {
      case RecordState.pause:
        _timer?.cancel();
      case RecordState.record:
        _startTimer();
      case RecordState.stop:
        _timer?.cancel();
        _recordDuration = 0;
    }
  }

  Future<bool> _isEncoderSupported(AudioEncoder encoder) async {
    final isSupported = await _audioRecorder.isEncoderSupported(
      encoder,
    );

    if (!isSupported) {
      debugPrint('${encoder.name} is not supported on this platform.');
      debugPrint('Supported encoders are:');

      for (final e in AudioEncoder.values) {
        if (await _audioRecorder.isEncoderSupported(e)) {
          debugPrint('- ${e.name}');
        }
      }
    }

    return isSupported;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRecordStopControl(),
        const SizedBox(width: 8),
        _buildText(),

        // if (_amplitude != null) ...[
        //   const SizedBox(height: 40),
        //   Text('Current: ${_amplitude?.current ?? 0.0}'),
        //   Text('Max: ${_amplitude?.max ?? 0.0}'),
        // ],
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Widget icon;

    if (_recordState != RecordState.stop) {
      icon = FunIcon.recordingSquare(
        iconsize: 32,
        circleSize: 80,
      );
    } else {
      icon = FunIcon.microphone(
        iconsize: 32,
        circleSize: 80,
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(60),
      child: SizedBox(child: icon),
      onTap: () {
        (_recordState != RecordState.stop) ? _stop() : _start();
      },
    );
  }

  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const BodySmallText(
      'Tap to record',
      color: FamilyAppTheme.primary60,
    );
  }

  Widget _buildTimer() {
    final minutes = _formatNumber(_recordDuration ~/ 60);
    final seconds = _formatNumber(_recordDuration % 60);

    return TitleMediumText(
      '$minutes : $seconds',
      color: FamilyAppTheme.error40,
    );
  }

  String _formatNumber(int number) {
    var numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}
