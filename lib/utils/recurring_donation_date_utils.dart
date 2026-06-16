import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart'
    as overview;
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';

/// Localized date/day formatting for recurring donation hint banners.
abstract final class RecurringDonationDateUtils {
  /// Returns a localized weekday or day-of-month string for hint copy.
  static String getLocalizedRecurringHintDay(
    DateTime date,
    overview.Frequency frequency,
    String locale,
  ) {
    switch (frequency) {
      case overview.Frequency.weekly:
        return DateFormat('EEEE', locale).format(date);
      case overview.Frequency.monthly:
      case overview.Frequency.quarterly:
      case overview.Frequency.halfYearly:
      case overview.Frequency.yearly:
        return _localizedDayOfMonth(date, locale);
      case overview.Frequency.daily:
      case overview.Frequency.none:
        return '';
    }
  }

  static String buildEndDateHintMessage({
    required AppLocalizations l10n,
    required overview.Frequency frequency,
    required DateTime startDate,
    required String locale,
  }) {
    final localizedDay =
        getLocalizedRecurringHintDay(startDate, frequency, locale);

    switch (frequency) {
      case overview.Frequency.weekly:
        return l10n.recurringDonationsEndDateHintEveryWeek(localizedDay);
      case overview.Frequency.monthly:
        return l10n.recurringDonationsEndDateHintEveryMonth(
          localizedDay,
          localizedDay,
        );
      case overview.Frequency.quarterly:
        return l10n.recurringDonationsEndDateHintEveryXMonth(localizedDay, '3');
      case overview.Frequency.halfYearly:
        return l10n.recurringDonationsEndDateHintEveryXMonth(localizedDay, '6');
      case overview.Frequency.yearly:
        final month = DateFormat('MMMM', locale).format(startDate);
        return l10n.recurringDonationsEndDateHintEveryYear(localizedDay, month);
      case overview.Frequency.daily:
      case overview.Frequency.none:
        return '';
    }
  }

  static String _localizedDayOfMonth(DateTime date, String locale) {
    final languageCode = locale.split(RegExp('[-_]')).first;
    if (languageCode == 'nl') {
      return '${date.day}e';
    }

    final momentLocalization =
        MomentLocalizations.byLocale(locale) ??
        MomentLocalizations.byLanguage(languageCode);

    if (momentLocalization != null) {
      return date.toMoment(localization: momentLocalization).format('Do');
    }

    return date.toMoment().format('Do');
  }
}
