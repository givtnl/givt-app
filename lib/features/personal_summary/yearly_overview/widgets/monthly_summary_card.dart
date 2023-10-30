import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/features/personal_summary/yearly_overview/cubit/yearly_overview_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:intl/intl.dart';

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    required this.currency,
    required this.country,
    super.key,
  });

  final String currency;
  final Country country;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return CardLayout(
      title: locals.budgetSummaryMonth,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCharts(context),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final locals = context.l10n;
    final textTheme = Theme.of(context).textTheme.bodySmall;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 8),
        Container(
          width: 16,
          height: 16,
          color: AppTheme.givtLightGreen,
        ),
        const SizedBox(width: 8),
        Text(
          locals.budgetYearlyOverviewDetailThroughGivt,
          style: textTheme!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 16,
          height: 16,
          color: AppTheme.givtBlue,
        ),
        const SizedBox(width: 8),
        Text(
          locals.budgetYearlyOverviewDetailNotThroughGivt,
          style: textTheme.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.givtBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildCharts(BuildContext context) {
    return BlocBuilder<YearlyOverviewCubit, YearlyOverviewState>(
      builder: (context, state) {
        if (state.status == YearlyOverviewStatus.loading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final mergedList = state.monthlyTotalSummaryMergedList;
        final referenceValue = _getReferenceValue(mergedList);
        final months = _getMonths(selectedYearInState: state.year);
        const maxWidgth = 100;
        const maxHeight = 16.0;
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: months.map((monthName) {
              final viaGivt = _getGivtFromList(
                searchedList: state.monthlyByOrganisationPerMonth,
                monthName: monthName,
              );
              final notViaGivt = _getGivtFromList(
                searchedList: state.externalDonationsPerMonth,
                monthName: monthName,
              );
              return Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(monthName),
                    ),
                    const SizedBox(width: 12),
                    _buildChart(
                      viaGivt,
                      referenceValue,
                      maxWidgth,
                      maxHeight,
                      notViaGivt,
                    ),
                    Expanded(child: Container()),
                    Text(
                      '$currency ${Util.formatNumberComma(viaGivt.amount + notViaGivt.amount, country)}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Returns a row with a title and a value
  ///
  Widget _buildChart(
    SummaryItem viaGivt,
    double referenceValue,
    int maxWidgth,
    double maxHeight,
    SummaryItem notViaGivt,
  ) {
    return Row(
      children: [
        Container(
          width: viaGivt.amount / referenceValue * maxWidgth,
          height: maxHeight,
          color: AppTheme.givtLightGreen,
        ),
        const SizedBox(height: 8),
        Container(
          width: notViaGivt.amount / referenceValue * maxWidgth,
          height: maxHeight,
          color: AppTheme.givtBlue,
        ),
      ],
    );
  }

  /// Returns the first item from the list
  /// that matches the monthName
  SummaryItem _getGivtFromList({
    required List<SummaryItem> searchedList,
    required String monthName,
  }) {
    return searchedList.firstWhere(
      (element) {
        final formattedDate =
            DateFormat.MMM().format(DateTime.parse('${element.key}-01'));
        return formattedDate == monthName;
      },
      orElse: SummaryItem.empty,
    );
  }

  /// Returns the highest value from the list
  double _getReferenceValue(List<SummaryItem> mergedList) {
    return mergedList
        .map((element) => element.amount)
        .reduce((a, b) => a > b ? a : b);
  }

  /// Returns a list of months in the format MMM
  List<String> _getMonths({required String selectedYearInState}) {
    final selectedYear = int.parse(selectedYearInState);
    final currentTime = DateTime.now();

    final months = List.generate(
      currentTime.year == selectedYear ? currentTime.month : 12,
      (index) => DateTime(currentTime.year, index + 1),
    );

    final monthNames =
        months.map((month) => DateFormat.MMM().format(month)).toList();
    return monthNames;
  }
}
