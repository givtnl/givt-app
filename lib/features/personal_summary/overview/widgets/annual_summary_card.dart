import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/summary_item.dart';

class AnnualSummaryCard extends StatelessWidget {
  const AnnualSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return CardLayout(
      title: locals.budgetSummaryYear,
      child: BlocBuilder<PersonalSummaryBloc, PersonalSummaryState>(
        builder: (context, state) {
          return Container(
            height: 200,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 8,
                    getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                    ) {
                      return BarTooltipItem(
                        rod.toY.round().toString(),
                        const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: const FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                ),
                // borderData: borderData,
                barGroups: _getBarGroups(state.annualGivts),
                gridData: const FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
              ),
            ),
          );
        },
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<SummaryItem> annualGivts) {
    return annualGivts
        .asMap()
        .map(
          (index, item) => MapEntry(
            index,
            BarChartGroupData(
              x: int.parse(item.key),
              // barRods: [
              //   BarChartRodData(
              //     width: 16,
              //     toY: item.amount,
              //   ),
              // ],
              showingTooltipIndicators: [0],
            ),
          ),
        )
        .values
        .toList();
  }
}
