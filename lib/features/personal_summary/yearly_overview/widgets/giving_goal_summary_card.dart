import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/personal_summary/giving_goal/pages/setup_giving_goal_bottom_sheet.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/features/personal_summary/yearly_overview/cubit/yearly_overview_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class GivingGoalSummaryCard extends StatelessWidget {
  const GivingGoalSummaryCard({
    required this.totalGivenInYear,
    required this.currency,
    required this.country,
    required this.currentYear,
    required this.previousYear,
    super.key,
  });

  final double totalGivenInYear;
  final String currentYear;
  final String previousYear;
  final String currency;
  final Country country;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return Row(
      children: [
        Card(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 32,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppTheme.givtPurple,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 24),
                Text(
                  '$currency ${Util.formatNumberComma(totalGivenInYear, country)}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  '${locals.budgetYearlyOverviewGivenIn} $currentYear',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _buildRightColumn(context)),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    final locals = context.l10n;
    final textTheme = Theme.of(context).textTheme.bodySmall;
    final yearlyOverviewState = context.read<YearlyOverviewCubit>().state;
    final isCurrentYear =
        yearlyOverviewState.year == DateTime.now().year.toString();
    return BlocBuilder<PersonalSummaryBloc, PersonalSummaryState>(
      builder: (context, state) {
        return Column(
          children: [
            Visibility(
              visible: state.givingGoal.monthlyGivingGoal > 0,
              child: GivingGoalCard(
                amount: '$currency ${Util.formatNumberComma(
                  state.givingGoal.yearlyGivingGoal,
                  country,
                )}',
                description: locals.budgetYearlyOverviewGivingGoalPerYear,
                amountTextTheme:
                    Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppTheme.givtPurple,
                          fontWeight: FontWeight.bold,
                        ),
                descriptionTextTheme: Theme.of(context).textTheme.bodyMedium!,
              ),
            ),
            Visibility(
              visible: state.givingGoal.yearlyGivingGoal == 0,
              child: GestureDetector(
                onTap: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (_) => BlocProvider.value(
                    value: context.read<PersonalSummaryBloc>(),
                    child: const SetupGivingGoalBottomSheet(),
                  ),
                ),
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        Text(
                          locals.budgetSummarySetGoalBold,
                          style: textTheme!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          locals.budgetSummarySetGoal,
                          style: textTheme,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildComparisonCard(
              state: state,
              yearlyOverviewState: yearlyOverviewState,
              context: context,
              locals: locals,
              textTheme: textTheme,
              comparisonResult: state.givingGoal.yearlyGivingGoal == 0
                  ? isCurrentYear
                      ? '${yearlyOverviewState.comparisonPercentageCurrentYear} %'
                      : '${yearlyOverviewState.comparisonPercentageLastYear} %'
                  : '''$currency ${state.givingGoal.yearlyGivingGoal > 0 ? Util.formatNumberComma(state.givingGoal.yearlyGivingGoal - totalGivenInYear, country) : Util.formatNumberComma(state.givingGoal.yearlyGivingGoal, country)}''',
              description: state.givingGoal.yearlyGivingGoal > 0
                  ? locals.budgetSummaryGivingGoalRest
                  : isCurrentYear
                      ? '${locals.budgetYearlyOverviewRelativeTo} \n$previousYear'
                      : '${locals.budgetYearlyOverviewVersus} $previousYear',
            ),
          ],
        );
      },
    );
  }

  Card _buildComparisonCard({
    required PersonalSummaryState state,
    required YearlyOverviewState yearlyOverviewState,
    required BuildContext context,
    required AppLocalizations locals,
    required TextStyle textTheme,
    required String comparisonResult,
    required String description,
  }) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                comparisonResult,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              description,
              style: textTheme,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
