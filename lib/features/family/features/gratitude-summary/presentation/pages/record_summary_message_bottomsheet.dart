import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/gratitude-summary/data/record_utils.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/fun_audio_recorder.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class RecordSummaryMessageBottomsheet extends StatefulWidget {
  const RecordSummaryMessageBottomsheet({super.key});

  static void show(
    BuildContext context,
    void Function(String) onDone,
  ) {
    showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => const RecordSummaryMessageBottomsheet(),
    ).then((value) {
      if (value != null) {
        // ignore: avoid_print
        onDone(value);
        print('Recorded message path: $value');
      }
    });
  }

  @override
  State<RecordSummaryMessageBottomsheet> createState() =>
      _RecordSummaryMessageBottomsheetState();
}

class _RecordSummaryMessageBottomsheetState
    extends State<RecordSummaryMessageBottomsheet> {
  bool recordedMessage = false;
  String? audioPath;

  @override
  void initState() {
    recordedMessage = false;
    audioPath = AudioRecorderMixin.audioPath;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FunBottomSheet(
      closeAction: () => Navigator.of(context).pop(),
      title: 'What did you talk about? ',
      content: Column(
        children: [
          const BodyMediumText(
            'Record a message with your family and keep your memories forever',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Center(
            child: FunAudioRecorder(
              onStop: (path) {
                setState(() {
                  audioPath = path;
                  recordedMessage = true;
                });
                Navigator.of(context).pop(audioPath);
              },
            ),
          ),
        ],
      ),
    );
  }
}
