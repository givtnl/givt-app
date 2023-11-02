import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/utils/utils.dart';

class AnnualBarChart extends StatelessWidget {
  const AnnualBarChart({
    required this.year,
    required this.amount,
    required this.yearGoal,
    required this.currency,
    required this.onTap,
    super.key,
  });

  final String year;
  final double amount;
  final String currency;
  final double yearGoal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            var width = constraints.maxWidth * amount / yearGoal;
            final isCurrentYear = DateTime.now().year.toString() == year;
            final isGoalAchieved = amount >= yearGoal;

            /// If the bar chart is overflowing, we need to reduce the width of the bar chart
            /// the -50 given by the padding and margins used in the widget and
            /// space for the amount text
            final isOverflowing = width > constraints.maxWidth - 50;
            width = isOverflowing ? constraints.maxWidth - 50 : width;

            final user = context.read<AuthCubit>().state.user;
            final country = Country.fromCode(user.country);
            final amountString = Util.formatNumberComma(
              amount,
              country,
            );
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isCurrentYear && !isGoalAchieved)
                      _buildUnachievedGoalChart(
                        context: context,
                        width: width,
                        amountString: amountString,
                        isCurrentYear: isCurrentYear,
                        constraints: constraints,
                      )
                    else
                      _buildAchievedGoalChart(
                        context: context,
                        width: width,
                        amountString: amountString,
                        isCurrentYear: isCurrentYear,
                        isOverflowing: isOverflowing,
                      ),
                  ],
                ),
                Text(year),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAchievedGoalChart({
    required BuildContext context,
    required double width,
    required String amountString,
    required bool isCurrentYear,
    bool isOverflowing = false,
  }) {
    var textColor = isCurrentYear ? AppTheme.givtLightGreen : AppTheme.givtBlue;
    if (isOverflowing) {
      textColor = Colors.white;
    }
    final textContaierList = [
      Container(
        width: width,
        height: 16,
        decoration: BoxDecoration(
          color: isCurrentYear ? AppTheme.givtLightGreen : AppTheme.givtBlue,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      Visibility(
        visible: !isOverflowing,
        child: const SizedBox(
          width: 8,
        ),
      ),
      Text(
        '$currency $amountString',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    ];
    if (isOverflowing) {
      return Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: textContaierList,
          ),
        ],
      );
    }
    return Row(
      children: textContaierList,
    );
  }

  /// Displays the bar chart for the current year if the goal is not achieved
  Widget _buildUnachievedGoalChart({
    required BuildContext context,
    required BoxConstraints constraints,
    required double width,
    required String amountString,
    required bool isCurrentYear,
    bool isOverflowing = false,
  }) {
    var textColor = isCurrentYear ? AppTheme.givtLightGreen : AppTheme.givtBlue;
    if (isOverflowing) {
      textColor = Colors.white;
    }

    final isAlmostAchieved = amount >= yearGoal * 0.8;

    return Row(
      children: [
        Visibility(
          visible: isAlmostAchieved,
          child: Container(
            width: width,
            height: 16,
            decoration: BoxDecoration(
              color: textColor,
            ),
          ),
        ),
        Stack(
          alignment: isAlmostAchieved ? Alignment.center : Alignment.centerLeft,
          children: [
            Container(
              width: width,
              height: 16,
              decoration: BoxDecoration(
                color: textColor,
              ),
            ),
            Container(
              width: constraints.maxWidth - 50,
              height: 16,
              decoration: BoxDecoration(
                color: AppTheme.givtLightGreen.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '$currency $amountString',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isAlmostAchieved
                            ? AppTheme.givtLightGreen
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '$currency $yearGoal',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
