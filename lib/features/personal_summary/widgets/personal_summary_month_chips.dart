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
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var month = 1; month <= 12; month++) ...[
              if (month > 1) const SizedBox(width: 8),
              FunFilterChip(
                label: DateFormat.MMM(locale).format(DateTime(2024, month)),
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}
