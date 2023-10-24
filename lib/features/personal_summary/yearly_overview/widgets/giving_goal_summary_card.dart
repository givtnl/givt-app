import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
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
              vertical: 16,
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
    return Column(
      children: [
        Card(
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
        // Card(
        //   elevation: 10,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8),
        //     child: Row(
        //       children: [
        //         Text(
        //           '3166%',
        //           style: Theme.of(context).textTheme.titleLarge!.copyWith(
        //                 fontWeight: FontWeight.bold,
        //               ),
        //         ),
        //         const SizedBox(width: 8),
        //         Text(
        //           '${locals.budgetYearlyOverviewRelativeTo} \n$previousYear',
        //           style: textTheme,
        //           softWrap: true,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
