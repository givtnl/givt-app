import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/family/features/history/models/donation.dart';
import 'package:givt_app/features/family/helpers/datetime_extension.dart';

class DonationItemWidget extends StatelessWidget {
  const DonationItemWidget({required this.donation, super.key,});
  final Donation donation;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: Row(
        children: [
          SvgPicture.asset(DonationState.getPicture(donation.state)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${donation.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: DonationState.getAmountColor(donation.state),
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: donation.medium == DonationMediumType.nfc ||
                        donation.isToGoal
                    ? size.width * 0.55
                    : size.width * 0.72,
                child: Text(
                  '${donation.isToGoal ? 'Family Goal: ' : ''}'
                  '${donation.organizationName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    color: Color(0xFF191C1D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                donation.state == DonationState.pending
                    ? 'Waiting for approval...'
                    : donation.date.formatDate(),
                style: const TextStyle(
                  color: Color(0xFF404943),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (donation.medium == DonationMediumType.nfc || donation.isToGoal)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Opacity(
                opacity: donation.state == DonationState.pending ? 0.6 : 1,
                child: SvgPicture.asset(
                  donation.isToGoal
                      ? 'assets/family/images/goal_flag.svg'
                      : 'assets/family/images/coin.svg',
                ),
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
