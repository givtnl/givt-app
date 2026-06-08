import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';

class ExternalDonationDeleteModal {
  const ExternalDonationDeleteModal._();

  static Future<void> show(
    BuildContext context, {
    required ExternalDonationDetailCubit cubit,
  }) {
    final locals = context.l10n;

    return FunModal(
      title: locals.externalDonationsDeleteModalTitle,
      subtitle: locals.externalDonationsDeleteModalMessage,
      closeAction: () => context.pop(),
      buttons: [
        FunButton(
          onTap: () async {
            context.pop();
            await cubit.confirmDeleteDonation();
          },
          text: locals.externalDonationsDeleteModalConfirm,
          analyticsEvent:
              AnalyticsEventName.externalDonationsDeleteConfirmClicked.toEvent(),
        ),
        FunButton(
          onTap: () => context.pop(),
          text: locals.externalDonationsDeleteModalCancel,
          variant: FunButtonVariant.secondary,
          analyticsEvent:
              AnalyticsEventName.externalDonationsDeleteCancelClicked.toEvent(),
        ),
      ],
    ).show(context, isDismissible: true);
  }
}

class ExternalDonationBulkDeleteModal {
  const ExternalDonationBulkDeleteModal._();

  static Future<void> show(
    BuildContext context, {
    required ExternalDonationDetailCubit cubit,
    required int selectedCount,
  }) {
    final locals = context.l10n;

    return FunModal(
      title: locals.externalDonationsBulkDeleteModalTitle,
      subtitle: locals.externalDonationsBulkDeleteModalMessage(selectedCount),
      closeAction: () => context.pop(),
      buttons: [
        FunButton(
          onTap: () async {
            context.pop();
            await cubit.confirmBulkDelete();
          },
          text: locals.externalDonationsBulkDeleteModalConfirm,
          analyticsEvent: AnalyticsEventName
              .externalDonationsBulkDeleteConfirmClicked
              .toEvent(),
        ),
        FunButton(
          onTap: () => context.pop(),
          text: locals.externalDonationsBulkDeleteModalCancel,
          variant: FunButtonVariant.secondary,
          analyticsEvent: AnalyticsEventName
              .externalDonationsBulkDeleteCancelClicked
              .toEvent(),
        ),
      ],
    ).show(context, isDismissible: true);
  }
}
