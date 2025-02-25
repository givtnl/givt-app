import 'package:flutter/foundation.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/gratitude-summary/data/record_utils.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:record/record.dart';

class AudioCubit extends CommonCubit<dynamic, dynamic> with AudioRecorderMixin {
  AudioCubit() : super(const BaseState.initial());

  late final AudioRecorder _audioRecorder;
  String? _path;

  void init() {
    _audioRecorder = AudioRecorder();
  }

  String? getRecordedAudio() => _path;

  Future<void> start() async {
    if (await _audioRecorder.isRecording()) {
      return;
    }
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

        await AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.audioRecordingStarted,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String?> stop() async {
    _path = await _audioRecorder.stop();

    await AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.audioRecordingStopped,
    );
    return _path;
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
}
