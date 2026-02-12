import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/record_cubit.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 72,
      width: MediaQuery.sizeOf(context).width,
      child: AnimatedWaveList(
        barBuilder: (Animation<double> animation, Amplitude amplitude) =>
            WaveFormBar(
          maxHeight: 8,
          animation: animation,
          amplitude: amplitude,
          color: widget.showRedVersion
              ? FunTheme.of(context).error60
              : FunTheme.of(context).primary70,
        ),
        stream: _recordCubit.getAmplitudeStream(),
      ),
    );
  }
}
