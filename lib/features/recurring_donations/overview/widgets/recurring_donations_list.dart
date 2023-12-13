import 'package:flutter/material.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/widgets/recurring_donation_item.dart';

class RecurringDonationsList extends StatefulWidget {
  const RecurringDonationsList({
    required this.recurringDonations,
    required this.onCancel,
    required this.onOverview,
    this.width,
    this.height,
    super.key,
  });

  final double? width;
  final double? height;
  final List<RecurringDonation> recurringDonations;
  final void Function(RecurringDonation recurringDonation) onCancel;
  final void Function(RecurringDonation recurringDonation) onOverview;

  @override
  State<RecurringDonationsList> createState() => _RecurringDonationsListState();
}

class _RecurringDonationsListState extends State<RecurringDonationsList> {
  RecurringDonation? selectedRecurringDonation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: SingleChildScrollView(
        child: Column(
          children: widget.recurringDonations
              .map(
                (recurringDonation) => RecurringDonationItem(
                  recurringDonation: recurringDonation,
                  isExtended: selectedRecurringDonation == recurringDonation,
                  onTap: () {
                    setState(() {
                      selectedRecurringDonation =
                          selectedRecurringDonation == recurringDonation
                              ? null
                              : recurringDonation;
                    });
                  },
                  onCancel: () {
                    widget.onCancel(recurringDonation);
                  },
                  onOverview: () {
                    widget.onOverview(recurringDonation);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
