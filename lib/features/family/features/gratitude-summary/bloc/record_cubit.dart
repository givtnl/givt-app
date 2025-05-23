import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/gratitude-summary/data/record_utils.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/record_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:waveform_flutter/waveform_flutter.dart' as waveform;

class RecordCubit extends CommonCubit<RecordUIModel, dynamic>
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

  bool _isRecording = false;

  bool isRecording() => _isRecording;

  void _emitData() {
    emitData(RecordUIModel(amplitude: _amplitude, isRecording: _isRecording));
  }

  Future<bool> requestPermission() async {
    _initAudioRecorder();
    final hasPermission = await _audioRecorder!.hasPermission();
    return hasPermission;
  }

  // Return whether the app currently has permission to use the microphone without showing a dialog
  Future<bool> _hasMicPermission() async =>
      await Permission.microphone.status == PermissionStatus.granted;

  Future<void> start({String? overrideAudioPath}) async {
    if (true == await _audioRecorder?.isRecording()) {
      return;
    }
    try {
      _initAudioRecorder();
      if (await _hasMicPermission()) {
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
        _isRecording = true;
        _emitData();

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
        .onAmplitudeChanged(const Duration(milliseconds: 60))
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
    if (_isRecording == false) {
      return null;
    }
    try {
      _path = await _audioRecorder!.stop();
      _isRecording = false;
      _emitData();

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
