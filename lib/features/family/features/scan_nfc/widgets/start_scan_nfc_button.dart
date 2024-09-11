import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class StartScanNfcButton extends StatelessWidget {
  const StartScanNfcButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FunButton(
      onTap: () {
        context.read<ScanNfcCubit>().readTag();
      },
      text: 'Start',
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.nfcStartButtonClicked,
      ),
    );
  }
}
