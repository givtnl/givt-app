import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/utils/datetime_extension.dart';

class PendingDonationWidget extends StatelessWidget {
  const PendingDonationWidget(
      {required this.donation, required this.size, super.key});
  final ChildDonation donation;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: const [4, 4],
        radius: const Radius.circular(20),
        strokeWidth: 2,
        color: const Color(0xFFF2DF7F),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: const Color(0xFFF2DF7F).withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Row(
            children: [
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${donation.amount.toStringAsFixed(2)} by ${donation.name}',
                    style: TextStyle(
                      color: DonationState.getAmountColor(donation.state),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
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
                      style: const TextStyle(
                        color: Color(0xFF654B14),
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    '${donation.date.formatDate()} - To be approved',
                    style: TextStyle(
                      color: donation.state == DonationState.pending
                          ? DonationState.getAmountColor(donation.state)
                          : const Color(0xFF2E2957),
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Spacer(),
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
        ),
      ),
    );
  }
}
