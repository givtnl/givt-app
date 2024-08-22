import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/family_history/models/allowance.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/string_datetime_extension.dart';
import 'package:givt_app/utils/utils.dart';

class AllowanceItemWidget extends StatelessWidget {
  const AllowanceItemWidget({
    required this.allowance,
    super.key,
  });

  final Allowance allowance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final locals = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: allowance.isNotSuccessful
          ? Colors.white
          : AppTheme.givtLightBackgroundBlue,
      child: Row(
        children: [
          if (allowance.isNotSuccessful)
            SvgPicture.asset('assets/images/donation_states_pending.svg')
          else
            SvgPicture.asset('assets/images/donation_states_added.svg'),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '+ \$${allowance.amount.toStringAsFixed(2)} ${locals.childHistoryTo} ${allowance.name}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: allowance.isNotSuccessful
                            ? AppTheme.childHistoryPendingDark
                            : AppTheme.childHistoryAllowance,
                      ),
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: Text(
                    allowance.isNotSuccessful
                        ? locals.allowanceOopsCouldntGetAllowances
                        : '${locals.childHistoryYay} ${allowance.name} ${locals.childHistoryCanContinueMakingADifference}',
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  allowance.isNotSuccessful
                      ? allowance.status == HistoryItemStatus.rejected
                          ? locals.weWillTryAgainNxtMonth
                          : locals.weWillTryAgainTmr
                      : allowance.date.formatDate(locals),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
