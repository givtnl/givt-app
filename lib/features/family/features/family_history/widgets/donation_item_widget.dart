import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/family_history/models/donation.dart';
import 'package:givt_app/features/family/features/family_history/models/donation_helper.dart';
import 'package:givt_app/features/family/features/family_history/widgets/actioned_donation_widget.dart';
import 'package:givt_app/features/family/features/family_history/widgets/pending_donation_widget.dart';

class DonationItemWidget extends StatelessWidget {
  const DonationItemWidget({
    required this.donation,
    super.key,
  });
  final Donation donation;
  @override
  Widget build(BuildContext context) {
    if (donation.state == DonationState.pending) {
      return PendingDonationWidget(donation: donation);
    }
    return ActionedDonationWidget(donation: donation);
  }
}
