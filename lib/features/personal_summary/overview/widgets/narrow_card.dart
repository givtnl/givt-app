import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/personal_summary/giving_goal/pages/setup_giving_goal_bottom_sheet.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class NarrowCard extends StatelessWidget {
  const NarrowCard({
    required this.isLeft,
    required this.userCountry,
    super.key,
  });

  final bool isLeft;
  final String userCountry;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final currency = Util.getCurrencySymbol(
      countryCode: userCountry,
    );

    return Card(
      elevation: 10,
      color: isLeft ? AppTheme.givtLightGreen : Colors.white,
      child: SizedBox(
        height: 165,
        width: isLeft ? size.width * 0.32 : size.width * 0.4,
        child: isLeft
            ? _buildSumaryThisMonth(currency, context)
            : _buildGivingGoal(context),
      ),
    );
  }

  Widget _buildSumaryThisMonth(String currency, BuildContext context) {
    final locals = context.l10n;
    final state = context.watch<PersonalSummaryBloc>().state;
    return Column(
      children: [
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$currency ${Util.formatNumberComma(state.totalSumPerMonth, Country.fromCode(userCountry))}',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            locals.budgetSummaryBalance,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildGivingGoal(BuildContext context) {
    final locals = context.l10n;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => BlocProvider.value(
            value: context.read<PersonalSummaryBloc>(),
            child: const SetupGivingGoalBottomSheet(),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'assets/images/givy_money.png',
            height: 60,
          ),
          Text(
            locals.budgetSummarySetGoalBold,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.givtBlue,
              fontWeight: FontWeight.bold,
              fontFamily: AppTheme.fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            locals.budgetSummarySetGoal,
            style: const TextStyle(
              color: AppTheme.givtBlue,
              fontFamily: AppTheme.fontFamily,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
