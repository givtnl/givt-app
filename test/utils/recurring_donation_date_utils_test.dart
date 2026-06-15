import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart'
    as overview;
import 'package:givt_app/l10n/arb/app_localizations_en.dart';
import 'package:givt_app/l10n/arb/app_localizations_nl.dart';
import 'package:givt_app/utils/recurring_donation_date_utils.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  final startDate = DateTime(2026, 6, 24);

  setUpAll(() async {
    await initializeDateFormatting('nl');
    await initializeDateFormatting('en');
  });

  group('getLocalizedRecurringHintDay', () {
    test('returns Dutch ordinal day for monthly frequency', () {
      expect(
        RecurringDonationDateUtils.getLocalizedRecurringHintDay(
          startDate,
          overview.Frequency.monthly,
          'nl',
        ),
        '24e',
      );
    });

    test('returns English ordinal day for monthly frequency', () {
      expect(
        RecurringDonationDateUtils.getLocalizedRecurringHintDay(
          startDate,
          overview.Frequency.monthly,
          'en',
        ),
        '24th',
      );
    });

    test('returns localized weekday for weekly frequency', () {
      expect(
        RecurringDonationDateUtils.getLocalizedRecurringHintDay(
          startDate,
          overview.Frequency.weekly,
          'nl',
        ),
        'woensdag',
      );
    });
  });

  group('buildEndDateHintMessage', () {
    test('uses weekly copy when frequency is weekly', () {
      final l10n = AppLocalizationsNl();

      final message = RecurringDonationDateUtils.buildEndDateHintMessage(
        l10n: l10n,
        frequency: overview.Frequency.weekly,
        startDate: startDate,
        locale: 'nl',
      );

      expect(
        message,
        'Je donatie vindt elke week plaats op de woensdag',
      );
    });

    test('uses monthly copy with Dutch ordinal when frequency is monthly', () {
      final l10n = AppLocalizationsNl();

      final message = RecurringDonationDateUtils.buildEndDateHintMessage(
        l10n: l10n,
        frequency: overview.Frequency.monthly,
        startDate: startDate,
        locale: 'nl',
      );

      expect(
        message,
        'Je donatie vindt plaats op de 24e van elke maand',
      );
    });

    test('uses English ordinal for monthly frequency', () {
      final l10n = AppLocalizationsEn();

      final message = RecurringDonationDateUtils.buildEndDateHintMessage(
        l10n: l10n,
        frequency: overview.Frequency.monthly,
        startDate: startDate,
        locale: 'en',
      );

      expect(
        message,
        'Your donation will occur on the 24th of every month',
      );
    });
  });
}
