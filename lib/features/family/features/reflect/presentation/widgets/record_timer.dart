import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';

class RecordTimerWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showRedVersion) recordMicRedIcon() else recordMicGreenIcon(),
        const SizedBox(height: 16),
        Text(
          '$minutes:$seconds',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppTheme.givtGreen40,
            fontSize: 57,
            fontFamily: 'Rouna',
            fontWeight: FontWeight.w700,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
