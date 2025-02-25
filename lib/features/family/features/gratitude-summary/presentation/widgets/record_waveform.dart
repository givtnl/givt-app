import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/record_cubit.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

class RecordWaveform extends StatefulWidget {
  const RecordWaveform({this.showRedVersion = false, super.key});

  final bool showRedVersion;

  @override
  State<RecordWaveform> createState() => _RecordWaveformState();
}

class _RecordWaveformState extends State<RecordWaveform> {
  final RecordCubit _recordCubit = getIt<RecordCubit>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.sizeOf(context).width,
      child: AnimatedWaveList(
        barBuilder: (Animation<double> animation, Amplitude amplitude) =>
            WaveFormBar(
          maxHeight: 3,
          animation: animation,
          amplitude: amplitude,
          color: widget.showRedVersion
              ? FamilyAppTheme.error80
              : FamilyAppTheme.primary70,
        ),
        stream: _recordCubit.getAmplitudeStream(),
      ),
    );
  }
}
