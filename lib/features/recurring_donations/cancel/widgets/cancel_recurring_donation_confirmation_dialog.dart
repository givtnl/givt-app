import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/recurring_donations/cancel/cubit/cancel_recurring_donation_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:go_router/go_router.dart';

class CancelRecurringDonationConfirmationDialog extends StatelessWidget {
  const CancelRecurringDonationConfirmationDialog({
    required this.recurringDonation,
    super.key,
  });

  final RecurringDonation recurringDonation;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocProvider(
      create: (_) => CancelRecurringDonationCubit(getIt()),
      child: BlocConsumer<CancelRecurringDonationCubit,
          CancelRecurringDonationState>(
        listener: (context, state) {
          if (state is CancelRecurringDonationSuccessState) {
            context.pop(true);
          }
        },
        builder: (context, state) {
          if (state is CancelRecurringDonationCancellingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CancelRecurringDonationErrorState) {
            return WarningDialog(
              onConfirm: () {
                context.pop(false);
              },
              title: locals.somethingWentWrong,
              content: locals.cancelRecurringDonationFailed,
            );
          } else if (state is CancelRecurringDonationConfirmationState) {
            return ConfirmationDialog(
              title: locals.cancelRecurringDonationAlertTitle(
                recurringDonation.collectGroup.orgName,
              ),
              content: locals.cancelRecurringDonationAlertMessage,
              confirmText: locals.yes,
              onConfirm: () {
                context
                    .read<CancelRecurringDonationCubit>()
                    .cancelRecurringDonations(recurringDonation);
              },
              cancelText: locals.no,
              onCancel: () => context.pop(false),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
