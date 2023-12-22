import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class MonthlyPastTwelveMonthsCard extends StatelessWidget {
  const MonthlyPastTwelveMonthsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final currency = Util.getCurrencySymbol(countryCode: user.country);
    final textTheme = Theme.of(context).textTheme.bodyMedium;
    final country = Country.fromCode(user.country);

    return CardLayout(
      title: locals.budgetSummaryMonth,
      child: BlocBuilder<PersonalSummaryBloc, PersonalSummaryState>(
        builder: (context, state) {
          final distanceLineFromBottom = (state.givingGoal.amount == 0
              ? state.averageGiven
              : state.givingGoal.yearlyGivingGoal / 12);
          final isGivingGoalSet = state.givingGoal.amount > 0;
          return SizedBox(
            height: 150,
            child: Stack(
              children: [
                Visibility(
                  visible: isGivingGoalSet,
                  child: Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppTheme.givtLightGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$currency ${Util.formatNumberComma(
                            state.givingGoal.monthlyGivingGoal,
                            country,
                          )}',
                          style: textTheme!.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: state.pastTwelveMonths.map(
                    (item) {
                      return MonthlyBarChart(
                        yearAndMonth: item.key,
                        amount: item.amount,
                      );
                    },
                  ).toList(),
                ),
                Visibility(
                  visible: isGivingGoalSet,
                  child: Positioned(
                    top: _calculateAverageLine(
                      distanceLineFromBottom,
                      state.maxInPastTwelveMonths,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppTheme.givtLightGreen,
                        border: Border(
                          bottom: BorderSide(
                            color: AppTheme.givtLightGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _calculateAverageLine(double value, double maxInTwelveMonths) {
    final percentageOfTotal = value / maxInTwelveMonths;

    final lineBottomHeight = 120 - 150 * percentageOfTotal;
    return lineBottomHeight;
  }
}
