import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/utils/datetime_extension.dart';

class DonationItemWidget extends StatelessWidget {
  const DonationItemWidget({required this.donation, super.key});
  final ChildDonation donation;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: donation.state == DonationState.pending
              ? const Color(0xFFF2DF7F).withOpacity(0.1)
              : Colors.white,
          border: Border.all(color: const Color(0xFFF2DF7F), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          if (donation.state != DonationState.pending)
            SvgPicture.asset(DonationState.getPicture(donation.state)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${donation.amount.toStringAsFixed(2)} by ${donation.name}',
                style: TextStyle(
                  color: DonationState.getAmountColor(donation.state),
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: donation.medium == DonationMediumType.nfc
                    ? size.width * 0.55
                    : size.width * 0.75,
                child: Text(
                  donation.organizationName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    color: donation.state == DonationState.pending
                        ? const Color(0xFF654B14)
                        : const Color(0xFF2E2957),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                donation.state == DonationState.pending
                    ? '${donation.date.formatDate()} - To be approved'
                    : donation.date.formatDate(),
                style: TextStyle(
                  color: donation.state == DonationState.pending
                      ? DonationState.getAmountColor(donation.state)
                      : const Color(0xFF2E2957),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (donation.medium == DonationMediumType.nfc &&
              donation.state != DonationState.pending)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Opacity(
                  opacity: donation.state == DonationState.pending ? 0.6 : 1,
                  child: SvgPicture.asset('assets/images/coin.svg')),
            )
          else if (donation.state == DonationState.pending)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: DonationState.getAmountColor(donation.state),
              ),
            )
        ],
      ),
    );
  }
}
