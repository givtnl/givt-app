import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_filters.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class DonationHistoryFilterSheet extends StatefulWidget {
  const DonationHistoryFilterSheet({required this.initial, super.key});

  final DonationHistoryFilters initial;

  static Future<DonationHistoryFilters?> show(
    BuildContext context, {
    required DonationHistoryFilters initial,
  }) {
    return showModalBottomSheet<DonationHistoryFilters>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      builder: (context) => DonationHistoryFilterSheet(initial: initial),
    );
  }

  @override
  State<DonationHistoryFilterSheet> createState() =>
      _DonationHistoryFilterSheetState();
}

class _DonationHistoryFilterSheetState
    extends State<DonationHistoryFilterSheet> {
  late DonationHistoryFilters _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunBottomSheet(
      title: locals.historyFilterDonations,
      closeAction: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _sectionLabel(locals.historyFilterDonationSource),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FunFilterChip(
                label: locals.personalSummaryThroughGivt,
                selected:
                    _draft.source == DonationHistorySourceFilter.givtProcessed,
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'source',
                    AnalyticsHelper.filterValueKey: 'givtProcessed',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleSource(
                    DonationHistorySourceFilter.givtProcessed,
                  ),
                ),
              ),
              FunFilterChip(
                label: locals.personalSummaryExternal,
                selected: _draft.source == DonationHistorySourceFilter.external,
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'source',
                    AnalyticsHelper.filterValueKey: 'external',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleSource(
                    DonationHistorySourceFilter.external,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionLabel(locals.historyFilterDonationType),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FunFilterChip(
                label: locals.personalSummaryOneOff,
                selected: _draft.type == DonationHistoryTypeFilter.oneOff,
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'type',
                    AnalyticsHelper.filterValueKey: 'oneOff',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleType(
                    DonationHistoryTypeFilter.oneOff,
                  ),
                ),
              ),
              FunFilterChip(
                label: locals.personalSummaryRecurring,
                selected: _draft.type == DonationHistoryTypeFilter.recurring,
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'type',
                    AnalyticsHelper.filterValueKey: 'recurring',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleType(
                    DonationHistoryTypeFilter.recurring,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionLabel(locals.historyFilterCategories),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FunFilterChip(
                mode: FunFilterChipMode.multiSelect,
                // Donation categories use personal-summary copy so en-US
                // shows Figma "Charity", not the org-type key "Non-profit".
                label: locals.personalSummaryCategoryCharity,
                selected: _draft.categories.contains(
                  DonationHistoryCategoryFilter.charity,
                ),
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'category',
                    AnalyticsHelper.filterValueKey: 'charity',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleCategory(
                    DonationHistoryCategoryFilter.charity,
                  ),
                ),
              ),
              FunFilterChip(
                mode: FunFilterChipMode.multiSelect,
                label: locals.personalSummaryCategoryChurch,
                selected: _draft.categories.contains(
                  DonationHistoryCategoryFilter.church,
                ),
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'category',
                    AnalyticsHelper.filterValueKey: 'church',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleCategory(
                    DonationHistoryCategoryFilter.church,
                  ),
                ),
              ),
              FunFilterChip(
                mode: FunFilterChipMode.multiSelect,
                label: locals.personalSummaryCategoryCampaign,
                selected: _draft.categories.contains(
                  DonationHistoryCategoryFilter.campaign,
                ),
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'category',
                    AnalyticsHelper.filterValueKey: 'campaign',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleCategory(
                    DonationHistoryCategoryFilter.campaign,
                  ),
                ),
              ),
              FunFilterChip(
                mode: FunFilterChipMode.multiSelect,
                label: locals.personalSummaryCategoryOther,
                selected: _draft.categories.contains(
                  DonationHistoryCategoryFilter.other,
                ),
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'category',
                    AnalyticsHelper.filterValueKey: 'other',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleCategory(
                    DonationHistoryCategoryFilter.other,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionLabel(locals.historyFilterDateRange),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: locals.historyFilterFrom,
                  hint: locals.historyFilterSelect,
                  date: _draft.startDate,
                  lastDate: _draft.endDate ?? DateTime.now(),
                  onDateSelected: (date) => setState(
                    () => _draft = _draft.setCustomDates(startDate: date),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DateField(
                  label: locals.historyFilterTo,
                  hint: locals.historyFilterSelect,
                  date: _draft.endDate,
                  firstDate: _draft.startDate,
                  onDateSelected: (date) => setState(
                    () => _draft = _draft.setCustomDates(endDate: date),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FunFilterChip(
                label: locals.historyFilterThisMonth,
                selected:
                    _draft.datePreset == DonationHistoryDatePreset.thisMonth,
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'datePreset',
                    AnalyticsHelper.filterValueKey: 'thisMonth',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleDatePreset(
                    DonationHistoryDatePreset.thisMonth,
                    now: DateTime.now(),
                  ),
                ),
              ),
              FunFilterChip(
                label: locals.historyFilterLastMonth,
                selected:
                    _draft.datePreset == DonationHistoryDatePreset.lastMonth,
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'datePreset',
                    AnalyticsHelper.filterValueKey: 'lastMonth',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleDatePreset(
                    DonationHistoryDatePreset.lastMonth,
                    now: DateTime.now(),
                  ),
                ),
              ),
              FunFilterChip(
                label: locals.historyFilterLastThreeMonths,
                selected:
                    _draft.datePreset ==
                    DonationHistoryDatePreset.lastThreeMonths,
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.donationHistoryFilterOptionClicked,
                  parameters: {
                    AnalyticsHelper.filterKey: 'datePreset',
                    AnalyticsHelper.filterValueKey: 'lastThreeMonths',
                  },
                ),
                onPressed: () => setState(
                  () => _draft = _draft.toggleDatePreset(
                    DonationHistoryDatePreset.lastThreeMonths,
                    now: DateTime.now(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: FunButton(
                  text: locals.historyFilterClearAll,
                  variant: FunButtonVariant.secondary,
                  isDisabled: !_draft.hasActive,
                  analyticsEvent: AnalyticsEvent(
                    AnalyticsEventName.donationHistoryFilterCleared,
                  ),
                  onTap: () =>
                      setState(() => _draft = DonationHistoryFilters.empty),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FunButton(
                  text: locals.historyFilterApply,
                  isDisabled: !_draft.hasActive && !widget.initial.hasActive,
                  analyticsEvent: AnalyticsEvent(
                    AnalyticsEventName.donationHistoryFilterApplied,
                    parameters: {
                      AnalyticsHelper.filterKey: _draft.hasActive.toString(),
                    },
                  ),
                  onTap: () => Navigator.of(context).pop(_draft),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return LabelSmallText(text, color: FunTheme.of(context).primary20);
  }
}

class _DateField extends StatefulWidget {
  const _DateField({
    required this.label,
    required this.hint,
    required this.date,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final String hint;
  final DateTime? date;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<_DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncText();
  }

  @override
  void didUpdateWidget(covariant _DateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) {
      _syncText();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncText() {
    final text = widget.date == null
        ? ''
        : formatDonationHistoryFilterDate(
            widget.date!,
            Localizations.localeOf(context).toLanguageTag(),
          );
    if (_controller.text != text) {
      _controller.text = text;
    }
  }

  DateTime _clampToRange(DateTime date, DateTime first, DateTime last) {
    if (date.isBefore(first)) {
      return first;
    }
    if (date.isAfter(last)) {
      return last;
    }
    return date;
  }

  Future<DateTime?> _showCompactDatePicker() {
    final now = DateTime.now();
    final firstDate = widget.firstDate ?? DateTime(2015);
    final lastDate = widget.lastDate ?? now;
    final initialDate = _clampToRange(
      widget.date ?? lastDate,
      firstDate,
      lastDate,
    );

    return showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleMediumText(
                  widget.label,
                  color: FunTheme.of(sheetContext).primary20,
                ),
                CalendarDatePicker(
                  initialDate: initialDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onDateChanged: (date) {
                    Navigator.of(sheetContext).pop(date);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return FunInput(
      label: widget.label,
      hintText: widget.hint,
      controller: _controller,
      readOnly: true,
      prefixIcon: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.solidCalendar,
            size: 24,
            color: theme.neutral40,
          ),
        ),
      ),
      analyticsEvent: AnalyticsEvent(
        AnalyticsEventName.donationHistoryFilterOptionClicked,
        parameters: {
          AnalyticsHelper.filterKey: 'dateInput',
          AnalyticsHelper.filterValueKey: widget.label,
        },
      ),
      onTap: () async {
        final picked = await _showCompactDatePicker();
        if (picked != null && mounted) {
          widget.onDateSelected(picked);
        }
      },
    );
  }
}
