import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

mixin AudioRecorderMixin {
  static const String audioPath = 'audio_summary_message.m4a';

  Future<void> recordFile(
    AudioRecorder recorder,
    RecordConfig config, {
    String? overrideAudioPath,
  }) async {
    final path = await _getPath(overrideAudioPath: overrideAudioPath);

    await recorder.start(config, path: path);
  }

  Future<void> recordStream(
    AudioRecorder recorder,
    RecordConfig config, {
    String? overrideAudioPath,
  }) async {
    final path = await _getPath(overrideAudioPath: overrideAudioPath);

    final file = File(path);

    final stream = await recorder.startStream(config);

    stream.listen(
      (data) {
        print(
          recorder.convertBytesToInt16(Uint8List.fromList(data)),
        );
        file.writeAsBytesSync(data, mode: FileMode.append);
      },
      onDone: () {
        print('End of stream. File written to $path.');
      },
    );
  }

  Future<String> _getPath({String? overrideAudioPath}) async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(
      dir.path,
      overrideAudioPath ?? audioPath,
    );
  }
}
