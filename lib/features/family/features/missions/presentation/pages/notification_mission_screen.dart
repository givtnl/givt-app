import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationMissionScreen extends StatelessWidget {
  const NotificationMissionScreen({super.key});

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final status = await Permission.notification.status;
      if (status.isGranted) {
        // TODO: KIDS-1861 Implement BE call to complete mission
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        title: 'Mission Reminders',
        leading: GivtBackButtonFlat(),
      ),
      body: Column(
        children: [
          const Spacer(flex: 2),
          FunCard(
            title:
                'Enable notifications so we can let you know when a mission is available',
            icon: FunIcon.bell(),
          ),
          const Spacer(flex: 3),
          FunButton(
              onTap: openAppSettings,
              text: 'Go to Settings',
              analyticsEvent: AnalyticsEvent(AmplitudeEvents.accountLocked)),
        ],
      ),
    );
  }
}
