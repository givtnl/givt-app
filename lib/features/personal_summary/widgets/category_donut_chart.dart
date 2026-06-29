import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_category_colors.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_section_card.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class CategoryDonutChart extends StatelessWidget {
  const CategoryDonutChart({
    required this.segments,
    required this.centerAmount,
    required this.formatAmount,
    super.key,
  });

  final List<ChartSegment> segments;
  final String centerAmount;
  final String Function(double amount) formatAmount;

  bool get _hasData => segments.any((segment) => segment.hasData);

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final locals = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonalSummarySectionHeader(
          title: locals.personalSummarySectionByCause,
          subtitle: locals.personalSummarySectionByCauseSubtitle,
        ),
        const SizedBox(height: 10),
        PersonalSummaryInnerCard(
          child: Column(
            children: [
              SizedBox(
                height: 156,
                width: 156,
                child: _hasData
                    ? CustomPaint(
                        painter: _DonutChartPainter(
                          segments: segments,
                          emptyColor: theme.neutral90,
                          colorForCategory: (category) =>
                              categoryColor(context, category),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TitleLargeText(centerAmount),
                              LabelSmallText(
                                locals.personalSummaryYearCenterLabel,
                                color: theme.neutral50,
                              ),
                            ],
                          ),
                        ),
                      )
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.neutral90,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: LabelSmallText(
                            locals.personalSummaryYearCenterLabel,
                            color: theme.neutral50,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 18),
              ...segments.map(
                (segment) => _CategoryLegendRow(
                  segment: segment,
                  formatAmount: formatAmount,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryLegendRow extends StatelessWidget {
  const _CategoryLegendRow({
    required this.segment,
    required this.formatAmount,
  });

  final ChartSegment segment;
  final String Function(double amount) formatAmount;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final percent = (segment.fraction * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.neutralVariant95),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: categoryFunIcon(segment.category),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelMediumText(
                  categoryLabel(context, segment.category),
                  color: theme.primary20,
                ),
                const SizedBox(height: 4),
                BodySmallText(
                  localsPercent(context, percent),
                  color: theme.neutral50,
                ),
              ],
            ),
          ),
          LabelMediumText(
            formatAmount(segment.amount),
            color: theme.primary50,
          ),
        ],
      ),
    );
  }

  String localsPercent(BuildContext context, int percent) {
    return context.l10n.personalSummaryGivingGoalPercent(percent);
  }
}

class _DonutChartPainter extends CustomPainter {
  _DonutChartPainter({
    required this.segments,
    required this.emptyColor,
    required this.colorForCategory,
  });

  final List<ChartSegment> segments;
  final Color emptyColor;
  final Color Function(GivingCategory category) colorForCategory;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 24.0;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final activeSegments =
        segments.where((segment) => segment.amount > 0).toList();
    if (activeSegments.isEmpty) {
      paint.color = emptyColor;
      canvas.drawArc(rect, 0, math.pi * 2, false, paint);
      return;
    }

    var startAngle = -math.pi / 2;
    for (final segment in activeSegments) {
      final sweepAngle = segment.fraction * math.pi * 2;
      paint.color = colorForCategory(segment.category);
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.segments != segments;
  }
}
