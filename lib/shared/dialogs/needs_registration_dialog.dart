import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/utils/mandate_popup_dismissal_tracker.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class NeedsRegistrationDialog {
  static Future<void> show(
    BuildContext context, {
    required MandatePopupDismissalTracker mandatePopupDismissalTracker,
  }) {
    if (!context.mounted) {
      return Future<void>.value();
    }

    final user = context.read<AuthCubit>().state.user;
    final isMandatory = mandatePopupDismissalTracker.shouldForceCompletion;
    final l10n = context.l10n;
    final router = GoRouter.of(context);

    AnalyticsHelper.logEvent(
      eventName: AnalyticsEventName.finalizeRegistrationModalShown,
      eventProperties: {'is_mandatory': isMandatory},
    );

    void navigateToFinalizeRegistration() {
      if (user.needRegistration) {
        router.goNamed(
          Pages.registration.name,
          queryParameters: {
            'email': user.email,
          },
        );
        return;
      }
      router.goNamed(Pages.sepaMandateExplanation.name);
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: !isMandatory,
      builder: (dialogContext) => PopScope(
        canPop: !isMandatory,
        child: FunModal(
          title: l10n.importantReminder,
          subtitle: l10n.finalizeRegistrationPopupText,
          closeAction: isMandatory
              ? null
              : () async {
                  await mandatePopupDismissalTracker.incrementDismissals();
                  if (!dialogContext.mounted) {
                    return;
                  }
                  Navigator.of(dialogContext).pop();
                },
          buttons: [
            FunButton(
              text: l10n.finalizeRegistration,
              analyticsEvent: AnalyticsEvent(
                AnalyticsEventName.finalizeRegistrationModalFinalizeClicked,
              ),
              onTap: () {
                if (!dialogContext.mounted) {
                  return;
                }
                Navigator.of(dialogContext).pop();
                navigateToFinalizeRegistration();
              },
            ),
            if (!isMandatory)
              FunButton(
                variant: FunButtonVariant.secondary,
                fullBorder: true,
                text: l10n.askMeLater,
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.finalizeRegistrationModalAskLaterClicked,
                ),
                onTap: () async {
                  await mandatePopupDismissalTracker.incrementDismissals();
                  if (!dialogContext.mounted) {
                    return;
                  }
                  Navigator.of(dialogContext).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
