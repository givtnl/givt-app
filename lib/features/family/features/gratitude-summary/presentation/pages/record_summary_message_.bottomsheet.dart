import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/gratitude-summary/data/record_utils.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/fun_audio_player.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/fun_audio_recorder.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class RecordSummaryMessageBottomsheet extends StatefulWidget {
  const RecordSummaryMessageBottomsheet({super.key, required this.name});
  final String name;

  static void show(
    BuildContext context,
    String name,
    void Function(String) onDone,
  ) {
    showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => RecordSummaryMessageBottomsheet(name: name),
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
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    audioPath = AudioRecorderMixin.audioPath;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FunBottomSheet(
      closeAction: () => Navigator.of(context).pop(),
      title: 'Record a message for ${widget.name}',
      content: Column(
        children: [
          const BodyMediumText(
            'Let them know you played the game',
          ),
          const SizedBox(height: 24),
          Center(
            child: showPlayer
                ? FunAudioPlayer(
                    source: audioPath!,
                    onDelete: () {
                      setState(() => showPlayer = false);
                    },
                  )
                : FunAudioRecorder(
                    onStop: (path) {
                      setState(() {
                        audioPath = path;
                        showPlayer = true;
                      });
                    },
                  ),
          ),
        ],
      ),
      primaryButton: FunButton(
        onTap: () {
          Navigator.of(context).pop(audioPath);
        },
        isDisabled: !showPlayer,
        text: 'Done',
        analyticsEvent:
            AnalyticsEvent(AmplitudeEvents.doneRecordingSummaryMessageClicked),
      ),
    );
  }
}
