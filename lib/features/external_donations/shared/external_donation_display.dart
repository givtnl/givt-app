import 'package:givt_app/core/datetime/api_date_time.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:intl/intl.dart';

/// Display helpers for [ExternalDonation] list and detail UI.
abstract final class ExternalDonationDisplay {
  /// Gift or series start date formatted for the user's locale.
  static String formatStartDate(ExternalDonation donation, String locale) {
    return ApiDateTime.formatYMMMd(donation.startDateTime, locale);
  }

  /// Locale-formatted calendar date for history rows and detail cards.
  static String formatDate(DateTime? date, String locale) {
    return ApiDateTime.formatYMMMd(date, locale);
  }

  /// Recurring frequency label including the day it falls on.
  static String formatFrequencyWithDay({
    required AppLocalizations locals,
    required ExternalDonationFrequency frequency,
    required DateTime anchorDate,
    required String locale,
  }) {
    final frequencyLabel = ExternalDonationFrequencyDropdown.frequencyLabel(
      locals,
      frequency,
    ).toLowerCase();

    switch (frequency) {
      case ExternalDonationFrequency.weekly:
        final weekday = DateFormat.EEEE(locale).format(anchorDate);
        return locals.externalDonationsManageFrequencyWeeklyOnDay(weekday);
      case ExternalDonationFrequency.monthly:
        return locals.externalDonationsManageFrequencyMonthlyOnDay(
          anchorDate.day.toString(),
        );
      case ExternalDonationFrequency.halfYearly:
        return locals.externalDonationsManageFrequencyHalfYearlyOnDay(
          anchorDate.day.toString(),
        );
      case ExternalDonationFrequency.yearly:
        final monthYear = DateFormat.yMMMM(locale).format(anchorDate);
        return locals.externalDonationsManageFrequencyYearlyOnDate(monthYear);
      case ExternalDonationFrequency.quarterly:
        return '$frequencyLabel on the ${anchorDate.day}';
      case ExternalDonationFrequency.once:
        return frequencyLabel;
    }
  }
}
