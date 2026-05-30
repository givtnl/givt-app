import 'package:equatable/equatable.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_draft.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_flow_step.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_preview_row.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
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

  /// One-off: org → type/amount → date (3). Recurring: + last gift + start (4).
  int get stepCount => draft.isOneOff == false ? 4 : 3;

  List<DateTime> get occurrencePreview {
    final draft = this.draft;
    if (draft.isOneOff != false ||
        draft.frequency == null ||
        draft.lastGiftDate == null ||
        draft.startMonthYear == null) {
      return const [];
    }
    return generateOccurrencePreview(
      startMonthYear: draft.startMonthYear!,
      lastGiftDate: draft.lastGiftDate!,
      frequency: draft.frequency!,
    );
  }

  int get hiddenPreviewCount {
    final total = occurrencePreview.length;
    if (total <= previewVisibleCount) {
      return 0;
    }
    return total - previewVisibleCount;
  }

  List<DateTime> get visiblePreview =>
      occurrencePreview.take(previewVisibleCount).toList();

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
      case ExternalDonationCreateFlowStep.lastGiftDate:
        return _lastGiftPreviewRows(
          currencySymbol,
          formatAmount,
          locals,
          locale,
        );
      case ExternalDonationCreateFlowStep.startMonthYear:
        return _startDatePreviewRows(
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
        draft.startMonthYear == null ||
        hiddenPreviewCount <= 0) {
      return null;
    }
    return locals.externalDonationsCreatePreviewMoreRecords(
      hiddenPreviewCount,
      _formatMonthYear(draft.startMonthYear!, locale),
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

  List<ExternalDonationCreatePreviewRow> _lastGiftPreviewRows(
    String currencySymbol,
    String Function(double amount) formatAmount,
    AppLocalizations locals,
    String locale,
  ) {
    final rows = <ExternalDonationCreatePreviewRow>[_summaryRow(currencySymbol, formatAmount, locals)];
    if (draft.lastGiftDate != null) {
      rows.add(
        ExternalDonationCreatePreviewRow(
          organisationName: draft.organisationName,
          typeTagLabel: _previewTypeTag(locals),
          amountLabel: draft.parsedAmount != null
              ? '$currencySymbol${formatAmount(draft.parsedAmount!)}'
              : null,
          primarySubtitle: _donationTypeSubtitle(locals),
          dateLabel: _formatShortDate(draft.lastGiftDate!, locale),
        ),
      );
    }
    return rows;
  }

  List<ExternalDonationCreatePreviewRow> _startDatePreviewRows(
    String currencySymbol,
    String Function(double amount) formatAmount,
    AppLocalizations locals,
    String locale,
  ) {
    final amount = draft.parsedAmount;
    final formattedAmount = amount != null
        ? '$currencySymbol${formatAmount(amount)}'
        : null;
    return visiblePreview.map((date) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final day = DateTime(date.year, date.month, date.day);
      final isFuture = day.isAfter(today);
      return ExternalDonationCreatePreviewRow(
        organisationName: draft.organisationName,
        typeTagLabel: _previewTypeTag(locals),
        amountLabel: formattedAmount,
        primarySubtitle: _donationTypeSubtitle(locals),
        dateLabel: _formatShortDate(date, locale),
        isUpcoming: isFuture,
        isCompleted: !isFuture,
      );
    }).toList();
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
    return occurrencePreview.take(previewVisibleCount).map((date) {
      final now = DateTime.now();
      final isFuture = date.isAfter(DateTime(now.year, now.month, now.day));
      final amount = draft.parsedAmount;
      return ExternalDonationCreatePreviewRow(
        organisationName: draft.organisationName,
        typeTagLabel: _previewTypeTag(locals),
        amountLabel: amount != null
            ? '$currencySymbol${formatAmount(amount)}'
            : null,
        primarySubtitle: _donationTypeSubtitle(locals),
        dateLabel: _formatShortDate(date, locale),
        isUpcoming: isFuture,
        isCompleted: !isFuture,
      );
    }).toList();
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
