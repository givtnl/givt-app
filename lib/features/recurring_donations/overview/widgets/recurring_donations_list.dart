import 'package:flutter/material.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/widgets/recurring_donation_item.dart';

class RecurringDonationsList extends StatelessWidget {
  const RecurringDonationsList({
    required this.recurringDonations,
    required this.onCancel,
    required this.onOverview,
    this.height,
    super.key,
  });

  final double? height;
  final List<RecurringDonation> recurringDonations;
  final void Function(RecurringDonation recurringDonation) onCancel;
  final void Function(RecurringDonation recurringDonation) onOverview;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        itemBuilder: (_, index) {
          return RecurringDonationItem(
            recurringDonation: recurringDonations[index],
            onCancel: () => onCancel(recurringDonations[index]),
            onOverview: () => onOverview(recurringDonations[index]),
          );
        },
        itemCount: recurringDonations.length,
      ),
    );
  }
}
