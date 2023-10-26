import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/children/parental_approval/cubit/parental_approval_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/string_datetime_extension.dart';

class ParentalApprovalConfirmationPage extends StatelessWidget {
  const ParentalApprovalConfirmationPage({
    required this.donation,
    super.key,
  });

  final ChildDonation donation;

  Future<void> _submitDecision(
    BuildContext context,
    DonationState decision,
  ) async {
    await context
        .read<ParentalApprovalCubit>()
        .submitDecision(decision: decision);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          //TODO: POEditor
          '${donation.name} would love to give',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.givtBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 25,
        ),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.givtBlue,
                ),
            children: [
              TextSpan(
                text: r'$',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.givtBlue,
                    ),
              ),
              TextSpan(
                text: donation.amount.toStringAsFixed(0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Text(
          //TODO: POEditor
          'to ${donation.organizationName} on ${donation.date.formatDate(context.l10n)}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.givtBlue,
              ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            TextButton(
              onPressed: () => _submitDecision(context, DonationState.declined),
              child: Text(
                //TODO: POEditor
                'Decline',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.childParentalApprovalDecline,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () =>
                    _submitDecision(context, DonationState.approved),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  //TODO: POEditor
                  'Approve',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.childHistoryApproved,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
