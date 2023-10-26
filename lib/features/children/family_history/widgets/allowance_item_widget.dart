import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/family_history/models/allowance.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/datetime_extension.dart';
import 'package:givt_app/utils/utils.dart';

class AllowanceItemWidget extends StatelessWidget {
  const AllowanceItemWidget({required this.allowance, super.key});
  final Allowance allowance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          SvgPicture.asset('assets/images/donation_states_added.svg'),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '+ \$${allowance.amount.toStringAsFixed(2)} ${locals.childHistoryTo} ${allowance.name}',
                style: const TextStyle(
                    color: AppTheme.childHistoryAllowance,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              SizedBox(
                width: size.width * 0.70,
                child: Text(
                  '${locals.childHistoryYay} ${allowance.name} ${locals.childHistoryCanContinueMakingADifference}',
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.givtBlue,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                allowance.date.formatDate(locals),
                style: const TextStyle(
                    color: AppTheme.givtBlue,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
