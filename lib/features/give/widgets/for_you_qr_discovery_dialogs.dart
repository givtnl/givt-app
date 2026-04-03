import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

/// FUN-styled dialogs for the For You QR discovery flow (ENG-458 / ENG-460).
class ForYouQrDiscoveryDialogs {
  ForYouQrDiscoveryDialogs._();

  static const _padding = EdgeInsets.fromLTRB(24, 20, 24, 24);
  static const _iconToTitle = 24.0;
  static const _titleToBody = 8.0;
  static const _bodyToButtons = 24.0;
  static const _betweenButtons = 12.0;

  /// Inactive QR: Yes = general funds; Cancel = back to For You list.
  /// Returns true for "Yes, please", false for Cancel.
  static Future<bool?> showInactiveQrDialog(
    BuildContext context, {
    required String organisationName,
    required IconData organisationIcon,
  }) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: _padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FunIcon(
                    iconData: organisationIcon,
                    iconColor: FamilyAppTheme.primary30,
                    iconSize: 40,
                    circleSize: 80,
                  ),
                  const SizedBox(height: _iconToTitle),
                  TitleMediumText(
                    l10n.invalidQRcodeTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _titleToBody),
                  BodyMediumText(
                    l10n.invalidQRcodeMessage(organisationName),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _bodyToButtons),
                  FunButton(
                    text: l10n.yesPlease,
                    analyticsEvent: AnalyticsEvent(
                      AnalyticsEventName.forYouQrInactiveYesPleaseTapped,
                    ),
                    onTap: () => Navigator.of(dialogContext).pop(true),
                  ),
                  const SizedBox(height: _betweenButtons),
                  FunButton(
                    variant: FunButtonVariant.secondary,
                    fullBorder: true,
                    text: l10n.cancel,
                    analyticsEvent: AnalyticsEvent(
                      AnalyticsEventName.forYouQrInactiveCancelTapped,
                    ),
                    onTap: () => Navigator.of(dialogContext).pop(false),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Inactive collect group: single action to For You list.
  static Future<void> showInactiveCollectGroupDialog(BuildContext context) {
    final l10n = context.l10n;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: _padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleMediumText(
                    l10n.inactiveCollectGroupTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _titleToBody),
                  BodyMediumText(
                    l10n.inactiveCollectGroupMessage,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _bodyToButtons),
                  FunButton(
                    text: l10n.buttonContinue,
                    analyticsEvent: AnalyticsEvent(
                      AnalyticsEventName
                          .forYouQrInactiveCollectGroupContinueTapped,
                    ),
                    onTap: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Not a Givt QR (body uses codeCanNotBeScanned). Returns `true` = try scan
  /// again, `false` = leave to For You list.
  static Future<bool?> showNonGivtQrDialog(BuildContext context) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: _padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleMediumText(
                    l10n.forYouQrNonGivtTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _titleToBody),
                  BodyMediumText(
                    l10n.codeCanNotBeScanned,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _bodyToButtons),
                  FunButton(
                    text: l10n.tryAgain,
                    analyticsEvent: AnalyticsEvent(
                      AnalyticsEventName.forYouQrNonGivtTryAgainTapped,
                    ),
                    onTap: () => Navigator.of(dialogContext).pop(true),
                  ),
                  const SizedBox(height: _betweenButtons),
                  FunButton(
                    variant: FunButtonVariant.secondary,
                    fullBorder: true,
                    text: l10n.cancel,
                    analyticsEvent: AnalyticsEvent(
                      AnalyticsEventName.forYouQrNonGivtLeaveTapped,
                    ),
                    onTap: () => Navigator.of(dialogContext).pop(false),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Decode / lookup failure.
  static Future<void> showNotFoundDialog(BuildContext context) {
    final l10n = context.l10n;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: _padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleMediumText(
                    l10n.somethingWentWrong,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _titleToBody),
                  BodyMediumText(
                    l10n.forYouQrNotFoundMessage,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _bodyToButtons),
                  FunButton(
                    text: l10n.buttonContinue,
                    analyticsEvent: AnalyticsEvent(
                      AnalyticsEventName.forYouQrNotFoundContinueTapped,
                    ),
                    onTap: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
