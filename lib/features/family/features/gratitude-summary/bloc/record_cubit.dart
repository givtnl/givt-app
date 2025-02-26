import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/gratitude-summary/data/record_utils.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/record_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:record/record.dart';
import 'package:waveform_flutter/waveform_flutter.dart' as waveform;

class RecordCubit extends CommonCubit<dynamic, dynamic>
    with AudioRecorderMixin {
  RecordCubit() : super(const BaseState.initial());

  AudioRecorder? _audioRecorder;
  String? _path;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  static const String audioPath = 'audio_recording_message.m4a';

  final StreamController<waveform.Amplitude> _amplitudeStreamController =
      StreamController<waveform.Amplitude>.broadcast();

  Stream<waveform.Amplitude> getAmplitudeStream() =>
      _amplitudeStreamController.stream;

  String? getRecordedAudio() => _path;

  void _emitData() {
    emitData(RecordUIModel(amplitude: _amplitude));
  }

  Future<bool> requestPermission() async {
    _initAudioRecorder();
    final hasPermission = await _audioRecorder!.hasPermission();
    return hasPermission;
  }

  Future<void> start({String? overrideAudioPath}) async {
    if (true == await _audioRecorder?.isRecording()) {
      return;
    }
    try {
      _initAudioRecorder();
      if (await _audioRecorder!.hasPermission()) {
        const encoder = AudioEncoder.aacLc;

        if (!await _isEncoderSupported(encoder)) {
          return;
        }

        final devs = await _audioRecorder!.listInputDevices();
        debugPrint(devs.toString());

        const config = RecordConfig(numChannels: 1);

        // Record to file
        await recordFile(
          _audioRecorder!,
          config,
          overrideAudioPath: overrideAudioPath ?? audioPath,
        );

        await AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.audioRecordingStarted,
        );
      } else {
        //TODO: Handle permission denied
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _initAudioRecorder() {
    _audioRecorder = AudioRecorder();
    _amplitudeSub = _audioRecorder!
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
      _amplitude = amp;
      _amplitudeStreamController.add(
        waveform.Amplitude(
          current: amp.current,
          max: amp.max,
        ),
      );
    });
  }

  Future<String?> stop() async {
    try {
      _path = await _audioRecorder!.stop();

      await AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.audioRecordingStopped,
      );
      await _audioRecorder!.dispose();
      _audioRecorder = null;
      return _path;
    } catch (e, s) {
      debugPrint('Error stopping audio recording: $e\n\n$s');
      return null;
    }
  }

  Future<bool> _isEncoderSupported(AudioEncoder encoder) async {
    final isSupported = await _audioRecorder!.isEncoderSupported(
      encoder,
    );

    if (!isSupported) {
      debugPrint('${encoder.name} is not supported on this platform.');
      debugPrint('Supported encoders are:');

      for (final e in AudioEncoder.values) {
        if (await _audioRecorder!.isEncoderSupported(e)) {
          debugPrint('- ${e.name}');
        }
      }
    }

    return isSupported;
  }
}
