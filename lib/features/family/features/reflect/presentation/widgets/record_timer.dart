import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/record_cubit.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/record_uimodel.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/record_waveform.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class RecordTimerWidget extends StatefulWidget {
  const RecordTimerWidget({
    required this.seconds,
    required this.minutes,
    required this.showRedVersion,
    super.key,
  });

  final String seconds;
  final String minutes;
  final bool showRedVersion;

  @override
  State<RecordTimerWidget> createState() => _RecordTimerWidgetState();
}

class _RecordTimerWidgetState extends State<RecordTimerWidget> {
  final RecordCubit _recordCubit = getIt<RecordCubit>();
  final ReflectAndShareRepository _repository =
      getIt<ReflectAndShareRepository>();

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _recordCubit,
      onInitial: (context) => _layout(),
      onData: (context, uiModel) {
        return _layout(uiModel: uiModel);
      },
    );
  }

  Column _layout({RecordUIModel? uiModel}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_repository.isAITurnedOn())
          RecordWaveform(
            showRedVersion: widget.showRedVersion,
          )
        else if (_repository.isAITurnedOn() && widget.showRedVersion)
          recordMicRedIcon()
        else if (!_repository.isAITurnedOn())
          recordMicGreenIcon(),
        const SizedBox(height: 16),
        Text(
          '${widget.minutes}:${widget.seconds}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.showRedVersion
                ? FamilyAppTheme.error60
                : FamilyAppTheme.primary70,
            fontSize: 57,
            fontFamily: 'Rouna',
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
