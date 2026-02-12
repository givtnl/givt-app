import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/give/utils/mandate_popup_dismissal_tracker.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:go_router/go_router.dart';

class NeedsRegistrationDialog {
  static Future<void> show(
    BuildContext context, {
    required MandatePopupDismissalTracker mandatePopupDismissalTracker,
  }) {
    final user = context.read<AuthCubit>().state.user;
    final isMandatory = mandatePopupDismissalTracker.shouldForceCompletion;

    return FunModal(
      title: context.l10n.importantReminder,
      subtitle: context.l10n.finalizeRegistrationPopupText,
      closeAction: isMandatory
          ? null
          : () async {
              await mandatePopupDismissalTracker.incrementDismissals();
              if (!context.mounted) {
                return;
              }
              context.pop();
            },
      buttons: [
        FunButton(
          text: context.l10n.finalizeRegistration,
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.finalizeRegistrationModalFinalizeClicked,
          ),
          onTap: () {
            if (user.needRegistration) {
              context
                ..goNamed(
                  Pages.registration.name,
                  queryParameters: {
                    'email': user.email,
                  },
                )
                ..pop();
              return;
            }
            context
              ..goNamed(Pages.sepaMandateExplanation.name)
              ..pop();
          },
        ),
        if (!isMandatory)
          FunButton(
            variant: FunButtonVariant.secondary,
            fullBorder: true,
            text: context.l10n.askMeLater,
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.finalizeRegistrationModalAskLaterClicked,
            ),
            onTap: () async {
              await mandatePopupDismissalTracker.incrementDismissals();
              if (!context.mounted) {
                return;
              }
              context.pop();
            },
          ),
      ],
    ).show(context, isDismissible: !isMandatory);
  }
}

