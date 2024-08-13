import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.totalWithinGivt,
    required this.totalOutsideGivt,
    required this.totalTaxRelief,
    required this.currency,
    required this.country,
    super.key,
  });

  final double totalWithinGivt;
  final double totalOutsideGivt;
  final double totalTaxRelief;
  final String currency;
  final Country country;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Card(
      elevation: 10,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppTheme.givtLightPurple,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRow(
              title: locals.budgetYearlyOverviewGivenThroughGivt,
              value: '$currency ${Util.formatNumberComma(
                totalWithinGivt,
                country,
              )}',
            ),
            const SizedBox(height: 8),
            _buildRow(
              title: locals.budgetYearlyOverviewGivenThroughNotGivt,
              value: '$currency ${Util.formatNumberComma(
                totalOutsideGivt,
                country,
              )}',
            ),
            const SizedBox(height: 8),
            _buildRow(
              title: locals.budgetYearlyOverviewGivenTotal,
              value: '$currency ${Util.formatNumberComma(
                totalWithinGivt + totalOutsideGivt,
                country,
              )}',
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildTaxReliefRow(
              title: locals.budgetYearlyOverviewGivenTotalTax,
              value: '$currency ${Util.formatNumberComma(
                totalTaxRelief,
                country,
              )}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxReliefRow({
    required String title,
    required String value,
    TextStyle textStyle = const TextStyle(
      fontStyle: FontStyle.italic,
      color: Colors.white,
    ),
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 16,
            ),
            Text(
              title,
              style: textStyle,
            ),
          ],
        ),
        Text(
          value,
          style: textStyle,
        ),
      ],
    );
  }

  Widget _buildRow({
    required String title,
    required String value,
    TextStyle textStyle = const TextStyle(
      color: Colors.white,
    ),
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textStyle,
        ),
        Text(
          value,
          style: textStyle,
        ),
      ],
    );
  }
}
