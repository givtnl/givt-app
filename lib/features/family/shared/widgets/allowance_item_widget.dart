import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/features/history/models/allowance.dart';
import 'package:givt_app/features/family/helpers/datetime_extension.dart';
import 'package:givt_app/utils/utils.dart';

class AllowanceItemWidget extends StatelessWidget {
  const AllowanceItemWidget({
    required this.allowance,
    super.key,
  });
  final Allowance allowance;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      color: AppTheme.historyAllowanceColor,
      child: Row(
        children: [
          SvgPicture.asset('assets/family/images/donation_states_added.svg'),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '+ \$${allowance.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF06509B),
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: size.width * 0.70,
                child: const Text(
                  'Awesome! Your parents added more allowance',
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF191C1D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                allowance.date.formatDate(),
                style: const TextStyle(
                  color: Color(0xFF404943),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
