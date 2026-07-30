import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_category_colors.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_section_card.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/util.dart';
import 'package:intl/intl.dart';

class MonthlyCategoryBarChart extends StatelessWidget {
  const MonthlyCategoryBarChart({
    required this.rows,
    required this.formatAmount,
    super.key,
  });

  final List<MonthlyCategoryRow> rows;
  final String Function(double amount) formatAmount;

  bool get _hasData => rows.any((row) => row.total > 0);

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final locals = context.l10n;
    final locale = Util.getLanguageTageFromLocale(context);
    final maxTotal = rows.fold<double>(
      0,
      (max, row) => row.total > max ? row.total : max,
    );

    return PersonalSummarySectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PersonalSummarySectionHeader(
            title: locals.personalSummarySectionMonthly,
            subtitle: locals.personalSummarySectionMonthlySubtitle,
          ),
          const SizedBox(height: 18),
          if (!_hasData)
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: theme.neutral90,
                borderRadius: BorderRadius.circular(12),
              ),
            )
          else ...[
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MonthlyRow(
                  row: row,
                  maxTotal: maxTotal,
                  formatAmount: formatAmount,
                  monthLabel: DateFormat.MMM(locale).format(
                    DateTime(2024, row.month),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            _MonthlyLegend(),
          ],
        ],
      ),
    );
  }
}

class _MonthlyRow extends StatelessWidget {
  const _MonthlyRow({
    required this.row,
    required this.maxTotal,
    required this.formatAmount,
    required this.monthLabel,
  });

  final MonthlyCategoryRow row;
  final double maxTotal;
  final String Function(double amount) formatAmount;
  final String monthLabel;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    if (row.total <= 0) {
      return Row(
        children: [
          SizedBox(
            width: 28,
            child: LabelSmallText(monthLabel, color: theme.neutral50),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: LabelSmallText('–', color: theme.neutral50),
          ),
        ],
      );
    }

    return Row(
      children: [
        SizedBox(
          width: 28,
          child: LabelSmallText(monthLabel, color: theme.neutral50),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalBarWidth = maxTotal > 0
                  ? (row.total / maxTotal) * constraints.maxWidth
                  : 0.0;

              return ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 14,
                  child: Stack(
                    children: [
                      for (
                        var index = 0;
                        index < monthlyBarCategoryOrder.length;
                        index++
                      )
                        _buildSegment(context, index, totalBarWidth),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 64,
          child: LabelSmallText(
            formatAmount(row.total),
            textAlign: TextAlign.end,
            color: theme.primary50,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSegment(BuildContext context, int index, double totalBarWidth) {
    final category = monthlyBarCategoryOrder[index];
    final amount = row.amountFor(category);
    if (amount <= 0 || row.total <= 0) {
      return const SizedBox.shrink();
    }

    final segmentFraction = amount / row.total;
    final precedingFraction =
        monthlyBarCategoryOrder
            .take(index)
            .map(row.amountFor)
            .fold<double>(0, (sum, value) => sum + value) /
        row.total;

    return Positioned(
      left: totalBarWidth * precedingFraction,
      child: SizedBox(
        width: totalBarWidth * segmentFraction,
        height: 14,
        child: ColoredBox(color: categoryColor(context, category)),
      ),
    );
  }
}

class _MonthlyLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: monthlyBarCategoryOrder.map((category) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: categoryColor(context, category),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            LabelSmallText(
              categoryLabel(context, category),
              color: theme.neutral50,
            ),
          ],
        );
      }).toList(),
    );
  }
}
