import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/string_datetime_extension.dart';

class ActionedDonationWidget extends StatelessWidget {
  const ActionedDonationWidget({
    required this.donation,
    super.key,
  });

  final ChildDonation donation;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          if (donation.state != DonationState.pending)
            SvgPicture.asset(DonationState.getPicture(donation.state)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${donation.amount.toStringAsFixed(2)} ${locals.childHistoryBy} ${donation.name}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: DonationState.getAmountColor(donation.state),
                    ),
              ),
              SizedBox(
                width: donation.medium == DonationMediumType.nfc ||
                        donation.isToGoal
                    ? size.width * 0.55
                    : size.width * 0.75,
                child: Text(
                    '${donation.isToGoal ? context.l10n.familyGoalPrefix : ''}'
                    '${donation.organizationName}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              Text(
                donation.date.formatDate(locals),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: donation.state == DonationState.pending
                          ? DonationState.getAmountColor(donation.state)
                          : AppTheme.givtBlue,
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
                      ? 'assets/images/goal_flag_small.svg'
                      : 'assets/images/coin.svg',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
