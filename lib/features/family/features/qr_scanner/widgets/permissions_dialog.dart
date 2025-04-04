import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/qr_scanner/widgets/permissions_dialog_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class FamilyAppPermissionDialog extends StatelessWidget {
  const FamilyAppPermissionDialog({
    required this.model,
    super.key,
    this.onClickClose,
    this.onClickSettings,
    this.hasDialogLayout = true,
  });

  final PermissionsUIModel model;
  final VoidCallback? onClickClose;
  final VoidCallback? onClickSettings;
  final bool hasDialogLayout;

  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    return Theme(
      data: theme,
      child: hasDialogLayout
          ? Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              child: _layout(theme, context),
            )
          : _layout(theme, context),
    );
  }

  Stack _layout(ThemeData theme, BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            hasDialogLayout ? 20 : 16,
            24,
            hasDialogLayout ? 24 : 64,
          ),
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
              SizedBox(
                height: hasDialogLayout ? 16 : 48,
              ),
              if (model.isSettings)
                FunButton(
                  onTap: () {
                    openAppSettings();
                    context.pop();
                    onClickSettings?.call();
                  },
                  text: 'Go to Settings',
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.permissionsGoToSettingsClicked,
                  ),
                )
              else
                FunButton(
                  onTap: model.onNextTap,
                  text: 'Next',
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.permissionsNextClicked,
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: IconButton(
            icon: const FaIcon(
                semanticLabel: 'xmark',
                FontAwesomeIcons.xmark),
            onPressed: () {
              SystemSound.play(SystemSoundType.click);
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.closePermissionsDialog,
              );
              context.pop();
              onClickClose?.call();
            },
          ),
        ),
      ],
    );
  }
}
