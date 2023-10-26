import 'package:flutter/material.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/children/family_history/widgets/actioned_donation_widget.dart';
import 'package:givt_app/features/children/family_history/widgets/pending_donation_widget.dart';

class DonationItemWidget extends StatelessWidget {
  const DonationItemWidget({required this.donation, super.key});
  final ChildDonation donation;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (donation.state == DonationState.pending) {
      return PendingDonationWidget(donation: donation, size: size);
    }
    return ActionedDonationWidget(donation: donation);
  }
}
