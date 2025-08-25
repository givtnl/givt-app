import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/missions/bloc/notif_mission_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationMissionScreen extends StatefulWidget {
  const NotificationMissionScreen({super.key});
  @override
  State<NotificationMissionScreen> createState() =>
      _NotificationMissionScreenState();
}

class _NotificationMissionScreenState extends State<NotificationMissionScreen>
    with WidgetsBindingObserver {
  final NotificationMissionsCubit cubit = getIt<NotificationMissionsCubit>();
  @override
  void initState() {
    super.initState();
    cubit.init();
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
      try {
        await cubit.updateNotificationPermission();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to update notification permission: $e'),
            ),
          );
        }
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
        body: BaseStateConsumer(
          cubit: cubit,
          onData: (context, uiModel) => Column(
            children: [
              const Spacer(flex: 2),
              FunCard(
                title:
                    'Enable notifications so we can let you know when a mission is available',
                icon: FunIcon.bell(),
              ),
              const Spacer(flex: 3),
              FunButton(
                  onTap: () {
                    if (uiModel.notifEnabled) {
                      context.goNamed(FamilyPages.profileSelection.name);
                    } else {
                      openAppSettings();
                    }
                  },
                  text: uiModel.notifEnabled ? context.l10n.buttonDone : 'Go to Settings',
                  analyticsEvent: AmplitudeEvents.notificationsGoToSettingsClicked.toEvent()),
            ],
          ),
        ));
  }
}
