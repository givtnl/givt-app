import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

/// Figma `45876:7405`: dimmed backdrop + centred modal with close, two actions.
Future<void> showGiftAidDeactivateDialog({
  required BuildContext context,
  required VoidCallback onKeepActive,
  required VoidCallback onTurnOff,
}) {
  final locals = context.l10n;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color.fromRGBO(0, 55, 55, 0.75),
    builder: (dialogContext) {
      return Theme(
        data: Theme.of(dialogContext),
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -8,
                  right: -8,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: const Color(0xFF003920),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TitleMediumText(
                      locals.manageGiftAidTurnOffTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    BodyMediumText(
                      locals.manageGiftAidTurnOffBody,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FunButton(
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        onKeepActive();
                      },
                      text: locals.manageGiftAidKeepActive,
                      analyticsEvent: AnalyticsEvent(
                        AnalyticsEventName.manageGiftAidKeepActiveClicked,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FunButton(
                      variant: FunButtonVariant.secondary,
                      fullBorder: true,
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        onTurnOff();
                      },
                      text: locals.manageGiftAidTurnOff,
                      analyticsEvent: AnalyticsEvent(
                        AnalyticsEventName.manageGiftAidTurnOffConfirmedClicked,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
