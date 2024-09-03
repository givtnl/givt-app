import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/permissions_dialog_ui_model.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/buttons/fun_button.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class FamilyAppPermissionDialog extends StatelessWidget {
  const FamilyAppPermissionDialog({required this.model, super.key});
  final PermissionsUIModel model;
  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    return Theme(
      data: theme,
      child: Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  model.image,
                  const SizedBox(height: 16),
                  Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    model.body,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  if (model.isSettings)
                    FunButton(
                      onTap: () {
                        AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvents.openAppPermissionsSettings,
                        );
                        openAppSettings();
                        context.pop();
                      },
                      text: 'Go to Settings',
                    )
                  else
                    FunButton(
                      onTap: model.onNextTap,
                      text: 'Next',
                    ),
                ],
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.xmark),
                onPressed: () {
                  SystemSound.play(SystemSoundType.click);
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.closePermissionsDialog,
                  );
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
