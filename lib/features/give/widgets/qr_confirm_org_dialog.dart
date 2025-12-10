import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';

/// Spacing constants extracted from Figma design
class _QrConfirmDialogSpacing {
  static const double iconToTitle = 24.0;
  static const double titleToDescription = 8.0;
  static const double descriptionToButton = 24.0;
  static const double betweenButtons = 12.0;
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(24, 20, 24, 24);
}

class QrConfirmOrgDialog extends StatelessWidget {
  const QrConfirmOrgDialog({
    required this.organizationName,
    required this.onConfirm,
    required this.onCancel,
    this.icon,
    super.key,
  });

  final String organizationName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final IconData? icon;

  static Future<void> show(
    BuildContext context, {
    required String organizationName,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    IconData? icon,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => QrConfirmOrgDialog(
        organizationName: organizationName,
        icon: icon,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = const FamilyAppTheme().toThemeData();

    return Theme(
      data: theme,
      child: Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: _QrConfirmDialogSpacing.contentPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Organization icon - dark green icon on light green circle
              FunIcon(
                iconData: icon ?? FontAwesomeIcons.church,
                circleColor: FamilyAppTheme.primary95,
                iconColor: FamilyAppTheme.primary30,
                iconSize: 40,
                circleSize: 80,
              ),
              const SizedBox(height: _QrConfirmDialogSpacing.iconToTitle),
              // Title - using TitleMediumText as per FUN design system
              TitleMediumText(
                locals.homeScreenConfirmOrgTitle(organizationName),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _QrConfirmDialogSpacing.titleToDescription),
              // Description - using BodyMediumText as per FUN design system
              BodyMediumText(
                locals.homeScreenConfirmOrgDescription,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _QrConfirmDialogSpacing.descriptionToButton),
              // Primary button - "Yes, confirm"
              FunButton(
                onTap: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                text: locals.homeScreenConfirmOrgYes,
                analyticsEvent: AmplitudeEvents.qrCodeScanned.toEvent(
                  parameters: {
                    'goal_name': organizationName,
                    'confirmed': true,
                  },
                ),
              ),
              const SizedBox(height: _QrConfirmDialogSpacing.betweenButtons),
              // Secondary button - "Cancel"
              FunButton.secondary(
                onTap: () {
                  Navigator.of(context).pop();
                  onCancel();
                },
                text: locals.cancel,
                analyticsEvent: AmplitudeEvents.qrCodeScanned.toEvent(
                  parameters: {
                    'goal_name': organizationName,
                    'confirmed': false,
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

