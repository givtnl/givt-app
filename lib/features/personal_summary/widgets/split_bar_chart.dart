import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_section_card.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_tappable_row.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class SplitBarChart extends StatelessWidget {
  const SplitBarChart({
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.data,
    required this.primaryColor,
    required this.secondaryColor,
    required this.primaryLabelColor,
    required this.secondaryLabelColor,
    required this.primaryIconColor,
    required this.secondaryIconColor,
    required this.formatAmount,
    this.onPrimaryTap,
    this.onSecondaryTap,
    this.primaryFilterValue,
    this.secondaryFilterValue,
    super.key,
  });

  final String title;
  final String subtitle;
  final String primaryLabel;
  final String secondaryLabel;
  final SplitBarData data;
  final Color primaryColor;
  final Color secondaryColor;
  final Color primaryLabelColor;
  final Color secondaryLabelColor;
  final Color primaryIconColor;
  final Color secondaryIconColor;
  final String Function(double amount) formatAmount;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onSecondaryTap;
  final String? primaryFilterValue;
  final String? secondaryFilterValue;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final primaryPercent = (data.primaryFraction * 100).round();
    final secondaryPercent = (data.secondaryFraction * 100).round();

    return PersonalSummarySectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PersonalSummarySectionHeader(
            title: title,
            subtitle: subtitle,
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 36,
              child: data.hasData
                  ? Row(
                      children: [
                        if (data.primaryFraction > 0)
                          Expanded(
                            flex: (data.primaryFraction * 1000).round().clamp(
                              1,
                              1000,
                            ),
                            child: ColoredBox(
                              color: primaryColor,
                              child: Center(
                                child: BodySmallText(
                                  context.l10n.personalSummaryGivingGoalPercent(
                                    primaryPercent,
                                  ),
                                  color: primaryLabelColor,
                                ),
                              ),
                            ),
                          ),
                        if (data.secondaryFraction > 0)
                          Expanded(
                            flex: (data.secondaryFraction * 1000).round().clamp(
                              1,
                              1000,
                            ),
                            child: ColoredBox(
                              color: secondaryColor,
                              child: Center(
                                child: BodySmallText(
                                  context.l10n.personalSummaryGivingGoalPercent(
                                    secondaryPercent,
                                  ),
                                  color: secondaryLabelColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : ColoredBox(color: theme.neutral90),
            ),
          ),
          const SizedBox(height: 16),
          _SplitLegendRow(
            iconColor: primaryIconColor,
            label: primaryLabel,
            percent: primaryPercent,
            amount: formatAmount(data.primaryAmount),
            onTap: onPrimaryTap,
            filterValue: primaryFilterValue,
          ),
          _SplitLegendRow(
            iconColor: secondaryIconColor,
            label: secondaryLabel,
            percent: secondaryPercent,
            amount: formatAmount(data.secondaryAmount),
            showDivider: false,
            onTap: onSecondaryTap,
            filterValue: secondaryFilterValue,
          ),
        ],
      ),
    );
  }
}

class _SplitLegendRow extends StatelessWidget {
  const _SplitLegendRow({
    required this.iconColor,
    required this.label,
    required this.percent,
    required this.amount,
    this.showDivider = true,
    this.onTap,
    this.filterValue,
  });

  final Color iconColor;
  final String label;
  final int percent;
  final String amount;
  final bool showDivider;
  final VoidCallback? onTap;
  final String? filterValue;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    final row = Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.solidCircle,
              size: 12,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelMediumText(label, color: theme.primary20),
              const SizedBox(height: 4),
              BodySmallText(
                context.l10n.personalSummaryGivingGoalPercent(percent),
                color: theme.neutral50,
              ),
            ],
          ),
        ),
        LabelMediumText(amount, color: theme.primary50),
      ],
    );

    if (onTap == null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: showDivider ? theme.neutralVariant95 : Colors.transparent,
            ),
          ),
        ),
        child: row,
      );
    }

    return PersonalSummaryTappableRow(
      onTap: onTap!,
      showBottomBorder: showDivider,
      analyticsEvent: AnalyticsEvent(
        AnalyticsEventName.personalSummarySplitRowClicked,
        parameters: {
          AnalyticsHelper.filterKey: 'split',
          AnalyticsHelper.filterValueKey: filterValue ?? label,
        },
      ),
      child: row,
    );
  }
}
