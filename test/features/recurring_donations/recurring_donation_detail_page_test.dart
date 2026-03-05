import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/l10n/arb/app_localizations_en.dart';

void main() {
  group('RecurringDonationDetail localization', () {
    test('recurringDonationsDetailEndedTag uses past tense in English', () {
      final l10n = AppLocalizationsEn();

      final result = l10n.recurringDonationsDetailEndedTag('1 Jan 2025');

      expect(result, 'Ended 1 Jan 2025');
    });
  });
}
