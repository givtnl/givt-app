import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/giving_goal_card.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class MonthlyGivingGoalProgress extends StatelessWidget {
  const MonthlyGivingGoalProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(
      countryCode: auth.user.country,
    );

    final amountTextTheme = Theme.of(context).textTheme.titleLarge!.copyWith(
          color: AppTheme.givtLightGreen,
          fontWeight: FontWeight.bold,
        );

    final descriptionTextTheme = Theme.of(context).textTheme.bodyMedium!;

    final country = Country.fromCode(auth.user.country);
    return BlocBuilder<PersonalSummaryBloc, PersonalSummaryState>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.55,
          child: Column(
            children: [
              _buildMonthlyGivingGoal(
                currency,
                state,
                country,
                amountTextTheme,
                locals,
                descriptionTextTheme,
                context,
              ),
              _buildRemainingGoal(
                currency,
                state,
                country,
                amountTextTheme,
                locals,
                descriptionTextTheme,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthlyGivingGoal(
    String currency,
    PersonalSummaryState state,
    Country country,
    TextStyle amountTextTheme,
    AppLocalizations locals,
    TextStyle descriptionTextTheme,
    BuildContext context,
  ) {
    return GivingGoalCard(
      amount: '$currency ${Util.formatNumberComma(
        state.givingGoal.monthlyGivingGoal,
        country,
      )}',
      description: locals.budgetSummaryGivingGoalMonth,
      amountTextTheme: amountTextTheme,
      descriptionTextTheme: descriptionTextTheme,
    );
  }

  Widget _buildRemainingGoal(
    String currency,
    PersonalSummaryState state,
    Country country,
    TextStyle amountTextTheme,
    AppLocalizations locals,
    TextStyle descriptionTextTheme,
  ) {
    final remainingAmount = state.givingGoal.isMonthly
        ? (state.givingGoal.amount.toDouble()) - state.totalSumPerMonth
        : state.givingGoal.monthlyGivingGoal - state.totalSumPerMonth;
    final isGoalAchieved =
        state.totalSumPerMonth >= state.givingGoal.monthlyGivingGoal;
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: isGoalAchieved
                  ? Image.asset(
                      'assets/images/givy_giving_goal.png',
                      height: 35,
                    )
                  : Text(
                      '$currency ${Util.formatNumberComma(
                        remainingAmount,
                        country,
                      )}',
                      style: amountTextTheme,
                    ),
            ),
            Expanded(
              child: Text(
                isGoalAchieved
                    ? locals.budgetSummaryGivingGoalReached
                    : locals.budgetSummaryGivingGoalRest,
                style: descriptionTextTheme,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
