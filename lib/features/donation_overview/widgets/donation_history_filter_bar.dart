import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_filters.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class DonationHistoryFilterBar extends StatelessWidget {
  const DonationHistoryFilterBar({
    required this.filters,
    required this.expandedDimension,
    required this.onChipPressed,
    super.key,
  });

  final DonationHistoryFilters filters;
  final DonationHistoryFilterDimension? expandedDimension;
  final ValueChanged<DonationHistoryFilterDimension> onChipPressed;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final ordered = filters.orderedDimensions();

    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        itemCount: ordered.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final dimension = ordered[index];
          return FunFilterChip(
            mode: FunFilterChipMode.dropdown,
            label: _label(locals, dimension),
            selected: filters.isDimensionActive(dimension),
            isExpanded: expandedDimension == dimension,
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName.donationHistoryFilterChipClicked,
              parameters: {AnalyticsHelper.filterKey: dimension.name},
            ),
            semanticsIdentifier: 'history-filter-${dimension.name}',
            onPressed: () => onChipPressed(dimension),
          );
        },
      ),
    );
  }

  String _label(
    AppLocalizations locals,
    DonationHistoryFilterDimension dimension,
  ) {
    return switch (dimension) {
      DonationHistoryFilterDimension.source =>
        locals.historyFilterDonationSource,
      DonationHistoryFilterDimension.type => locals.historyFilterDonationType,
      DonationHistoryFilterDimension.categories =>
        locals.historyFilterCategories,
      DonationHistoryFilterDimension.dateRange => locals.historyFilterDateRange,
    };
  }
}
