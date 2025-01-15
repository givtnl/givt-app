import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/missions/bloc/notif_mission_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationMissionScreen extends StatefulWidget {
  const NotificationMissionScreen({super.key});
  @override
  State<NotificationMissionScreen> createState() =>
      _NotificationMissionScreenState();
}

class _NotificationMissionScreenState extends State<NotificationMissionScreen>
    with WidgetsBindingObserver {
  final cubit = getIt<NotificationMissionsCubit>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      cubit.updateNotificationPermission();
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
              analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.notificationsGoToSettingsClicked)),
        ],
      ),
    );
  }
}
