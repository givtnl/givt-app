import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/utils/app_theme.dart';

class ParentalApprovalApprovedPage extends StatelessWidget {
  const ParentalApprovalApprovedPage({
    required this.donation,
    super.key,
  });

  final ChildDonation donation;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          //TODO: POEditor
          'Yes, ${donation.name} has made a difference!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.givtBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 25,
        ),
        SvgPicture.asset(
          'assets/images/donation_states_approved.svg',
          width: 90,
          height: 90,
        ),
        const SizedBox(
          height: 35,
        ),
        Text(
          //TODO: POEditor
          'Thank you',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.givtBlue,
              ),
        ),
      ],
    );
  }
}
