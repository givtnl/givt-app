import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/audio_player.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/audio_recorder.dart';

class RecordSummaryMessageScreen extends StatefulWidget {
  const RecordSummaryMessageScreen({super.key});

  @override
  State<RecordSummaryMessageScreen> createState() =>
      _RecordSummaryMessageScreenState();
}

class _RecordSummaryMessageScreenState
    extends State<RecordSummaryMessageScreen> {
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: showPlayer
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: AudioPlayer(
                    source: audioPath!,
                    onDelete: () {
                      setState(() => showPlayer = false);
                    },
                  ),
                )
              : Recorder(
                  onStop: (path) {
                    if (kDebugMode) print('Recorded file path: $path');
                    setState(() {
                      audioPath = path;
                      showPlayer = true;
                    });
                  },
                ),
        ),
      ),
    );
  }
}
