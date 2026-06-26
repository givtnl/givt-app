import 'package:equatable/equatable.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_draft.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_flow_step.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_preview_row.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:intl/intl.dart';

class ExternalDonationCreateUIModel extends Equatable {
  const ExternalDonationCreateUIModel({
    required this.draft,
    this.isSubmitting = false,
    this.previewVisibleCount = 3,
  });

  final ExternalDonationCreateDraft draft;
  final bool isSubmitting;
  final int previewVisibleCount;

  /// Org → type/amount → date (3 steps for one-off and recurring).
  int get stepCount => 3;

  List<DateTime> get occurrencePreview {
    final draft = this.draft;
    if (draft.isOneOff != false ||
        draft.frequency == null ||
        draft.seriesStartDate == null) {
      return const [];
    }
    return generateOccurrencePreview(
      seriesStartDate: draft.seriesStartDate!,
      frequency: draft.frequency!,
    );
  }

  int get hiddenPastPreviewCount {
    final split = _splitOccurrencePreview();
    if (split.past.isEmpty) {
      return 0;
    }
    final pastSlots = previewVisibleCount - (split.upcoming.isNotEmpty ? 1 : 0);
    final shownPast = pastSlots < split.past.length ? pastSlots : split.past.length;
    return split.past.length - shownPast;
  }

  ({List<DateTime> upcoming, List<DateTime> past}) _splitOccurrencePreview({
    DateTime? now,
  }) {
    final all = occurrencePreview;
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);

    final upcoming = <DateTime>[];
    final past = <DateTime>[];
    for (final date in all) {
      final day = DateTime(date.year, date.month, date.day);
      if (day.isAfter(today)) {
        upcoming.add(date);
      } else {
        past.add(date);
      }
    }
    return (upcoming: upcoming, past: past);
  }

  /// Upcoming occurrence first, then most recent past (capped).
  List<DateTime> get visiblePreview => _recurringPreviewDatesForDisplay();

  List<DateTime> _recurringPreviewDatesForDisplay({DateTime? now}) {
    final split = _splitOccurrencePreview(now: now);
    if (split.upcoming.isEmpty && split.past.isEmpty) {
      return const [];
    }

    final displayed = <DateTime>[];
    if (split.upcoming.isNotEmpty) {
      displayed.add(split.upcoming.first);
    }
    for (final date in split.past.reversed) {
      if (displayed.length >= previewVisibleCount) {
        break;
      }
      displayed.add(date);
    }
    return displayed;
  }

  ExternalDonationFrequency? get effectiveFrequency {
    if (draft.isOneOff == true) {
      return ExternalDonationFrequency.once;
    }
    return draft.frequency;
  }

  List<ExternalDonationCreatePreviewRow> previewRowsForStep(
    ExternalDonationCreateFlowStep step, {
    required String currencySymbol,
    required String Function(double amount) formatAmount,
    required AppLocalizations locals,
    required String locale,
  }) {
    if (!draft.hasOrganisation) {
      return const [];
    }

    switch (step) {
      case ExternalDonationCreateFlowStep.organisation:
        return const [];
      case ExternalDonationCreateFlowStep.donationType:
        return [_summaryRow(currencySymbol, formatAmount, locals)];
      case ExternalDonationCreateFlowStep.oneOffDate:
        return [_oneOffPreviewRow(currencySymbol, formatAmount, locals, locale)];
      case ExternalDonationCreateFlowStep.seriesStartDate:
        return _seriesStartDatePreviewRows(
          currencySymbol,
          formatAmount,
          locals,
          locale,
        );
      case ExternalDonationCreateFlowStep.success:
        return _successPreviewRows(
          currencySymbol,
          formatAmount,
          locals,
          locale,
        );
    }
  }

  String? previewMoreRecordsLabel(AppLocalizations locals, String locale) {
    if (draft.isOneOff != false ||
        draft.seriesStartDate == null ||
        hiddenPastPreviewCount <= 0) {
      return null;
    }
    return locals.externalDonationsCreatePreviewMoreRecords(
      hiddenPastPreviewCount,
      _formatMonthYear(draft.seriesStartDate!, locale),
    );
  }

  static String _formatShortDate(DateTime date, String locale) =>
      DateFormat('d MMM yyyy', locale).format(date);

  static String _formatMonthYear(DateTime date, String locale) =>
      DateFormat('MMMM yyyy', locale).format(date);

  ExternalDonationCreatePreviewRow _summaryRow(
    String currencySymbol,
    String Function(double amount) formatAmount,
    AppLocalizations locals,
  ) {
    final amount = draft.parsedAmount;
    return ExternalDonationCreatePreviewRow(
      organisationName: draft.organisationName,
      typeTagLabel: _previewTypeTag(locals),
      amountLabel: amount != null ? '$currencySymbol${formatAmount(amount)}' : null,
      primarySubtitle: _donationTypeSubtitle(locals),
    );
  }

  ExternalDonationCreatePreviewRow _oneOffPreviewRow(
    String currencySymbol,
    String Function(double amount) formatAmount,
    AppLocalizations locals,
    String locale,
  ) {
    final amount = draft.parsedAmount;
    final date = draft.dateMade;
    return ExternalDonationCreatePreviewRow(
      organisationName: draft.organisationName,
      typeTagLabel: _previewTypeTag(locals),
      amountLabel: amount != null ? '$currencySymbol${formatAmount(amount)}' : null,
      primarySubtitle: locals.externalDonationsCreateFrequencyOneOff,
      dateLabel: date != null ? _formatShortDate(date, locale) : null,
    );
  }

  List<ExternalDonationCreatePreviewRow> _seriesStartDatePreviewRows(
    String currencySymbol,
    String Function(double amount) formatAmount,
    AppLocalizations locals,
    String locale,
  ) {
    if (draft.seriesStartDate == null || occurrencePreview.isEmpty) {
      return [_summaryRow(currencySymbol, formatAmount, locals)];
    }
    return _recurringPreviewRowsFromDates(
      visiblePreview,
      currencySymbol: currencySymbol,
      formatAmount: formatAmount,
      locals: locals,
      locale: locale,
    );
  }

  List<ExternalDonationCreatePreviewRow> _successPreviewRows(
    String currencySymbol,
    String Function(double amount) formatAmount,
    AppLocalizations locals,
    String locale,
  ) {
    if (draft.isOneOff == true) {
      return [_oneOffPreviewRow(currencySymbol, formatAmount, locals, locale)];
    }
    if (occurrencePreview.isEmpty) {
      return [_summaryRow(currencySymbol, formatAmount, locals)];
    }
    return _recurringPreviewRowsFromDates(
      _recurringPreviewDatesForDisplay(),
      currencySymbol: currencySymbol,
      formatAmount: formatAmount,
      locals: locals,
      locale: locale,
    );
  }

  List<ExternalDonationCreatePreviewRow> _recurringPreviewRowsFromDates(
    List<DateTime> dates, {
    required String currencySymbol,
    required String Function(double amount) formatAmount,
    required AppLocalizations locals,
    required String locale,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);

    return dates.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;
      final day = DateTime(date.year, date.month, date.day);
      final isFuture = day.isAfter(today);
      final isFaded = dates.length == previewVisibleCount &&
          index == dates.length - 1 &&
          !isFuture;
      return _recurringHistoryRow(
        currencySymbol: currencySymbol,
        formatAmount: formatAmount,
        locals: locals,
        locale: locale,
        date: date,
        isUpcoming: isFuture,
        isCompleted: !isFuture,
        isFaded: isFaded,
      );
    }).toList();
  }

  ExternalDonationCreatePreviewRow _recurringHistoryRow({
    required String currencySymbol,
    required String Function(double amount) formatAmount,
    required AppLocalizations locals,
    required String locale,
    required DateTime date,
    bool isUpcoming = false,
    bool isCompleted = false,
    bool isFaded = false,
  }) {
    final amount = draft.parsedAmount;
    return ExternalDonationCreatePreviewRow(
      organisationName: draft.organisationName,
      typeTagLabel: _previewTypeTag(locals),
      amountLabel: amount != null
          ? '$currencySymbol${formatAmount(amount)}'
          : null,
      primarySubtitle: _donationTypeSubtitle(locals),
      dateLabel: _formatShortDate(date, locale),
      isUpcoming: isUpcoming,
      isCompleted: isCompleted,
      isFaded: isFaded,
    );
  }

  String _previewTypeTag(AppLocalizations locals) =>
      locals.externalDonationsCreatePreviewTypeTag;

  String? _donationTypeSubtitle(AppLocalizations locals) {
    if (draft.isOneOff == true) {
      return locals.externalDonationsCreateFrequencyOneOff;
    }
    if (draft.isOneOff == false && draft.frequency != null) {
      return ExternalDonationFrequencyDropdown.frequencyLabel(
        locals,
        draft.frequency!,
      );
    }
    return null;
  }

  ExternalDonationCreateUIModel copyWith({
    ExternalDonationCreateDraft? draft,
    bool? isSubmitting,
    int? previewVisibleCount,
  }) {
    return ExternalDonationCreateUIModel(
      draft: draft ?? this.draft,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      previewVisibleCount: previewVisibleCount ?? this.previewVisibleCount,
    );
  }

  @override
  List<Object?> get props => [draft, isSubmitting, previewVisibleCount];
}
