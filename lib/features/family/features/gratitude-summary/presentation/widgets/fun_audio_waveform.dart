import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/record_cubit.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

class FunAudioWaveform extends StatefulWidget {
  const FunAudioWaveform({super.key});

  @override
  State<FunAudioWaveform> createState() => _FunAudioWaveformState();
}

class _FunAudioWaveformState extends State<FunAudioWaveform> {
  final RecordCubit _recordCubit = getIt<RecordCubit>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.sizeOf(context).width,
      child: AnimatedWaveList(
        barBuilder: (Animation<double> animation, Amplitude amplitude) =>
            WaveFormBar(
          animation: animation,
          amplitude: amplitude,
          color: FamilyAppTheme.primary70,
            ),
        stream: _recordCubit.getAmplitudeStream(),
      ),
    );
  }
}
