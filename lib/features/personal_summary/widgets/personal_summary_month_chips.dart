import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/util.dart';
import 'package:intl/intl.dart';

/// Horizontal single-select month chips (Jan–Dec) for the personal summary.
class PersonalSummaryMonthChips extends StatelessWidget {
  const PersonalSummaryMonthChips({
    required this.selectedMonth,
    required this.onMonthPressed,
    super.key,
  });

  final int? selectedMonth;
  final ValueChanged<int> onMonthPressed;

  @override
  Widget build(BuildContext context) {
    final locale = Util.getLanguageTageFromLocale(context);

    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: 12,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final month = index + 1;
          final label = DateFormat.MMM(locale).format(DateTime(2024, month));
          return FunFilterChip(
            label: label,
            selected: selectedMonth == month,
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName.personalSummaryMonthChipClicked,
              parameters: {
                AnalyticsHelper.filterKey: 'month',
                AnalyticsHelper.filterValueKey: month.toString(),
              },
            ),
            semanticsIdentifier: 'personal-summary-month-$month',
            onPressed: () => onMonthPressed(month),
          );
        },
      ),
    );
  }
}
