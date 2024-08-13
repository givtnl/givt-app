import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/family_history/models/topup.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/string_datetime_extension.dart';
import 'package:givt_app/utils/utils.dart';

class TopupItemWidget extends StatelessWidget {
  const TopupItemWidget({required this.topup, super.key});
  final Topup topup;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final locals = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: topup.isNotSuccessful
          ? Colors.white
          : AppTheme.givtLightBackgroundBlue,
      child: Row(
        children: [
          if (topup.isNotSuccessful)
            SvgPicture.asset('assets/images/donation_states_declined.svg')
          else
            SvgPicture.asset('assets/images/donation_states_added.svg'),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '+\$${topup.amount.toStringAsFixed(2)} ${locals.childHistoryTo} ${topup.name}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: topup.isNotSuccessful
                          ? AppTheme.childHistoryDeclined
                          : AppTheme.childHistoryAllowance,
                    ),
              ),
              SizedBox(
                width: size.width * 0.7,
                child: Text(
                  topup.isNotSuccessful
                      ? "Oops! We couldn't top up your child’s Wallet."
                      : '${locals.childHistoryYay} ${topup.name} ${locals.childHistoryCanContinueMakingADifference}',
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                topup.isNotSuccessful
                    ? 'Please try again later.'
                    : topup.date.formatDate(locals),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
