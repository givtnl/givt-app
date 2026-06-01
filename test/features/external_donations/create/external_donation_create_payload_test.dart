import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_draft.dart';
import 'package:givt_app/features/external_donations/create/repositories/external_donation_create_repository.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';

void main() {
  group('ExternalDonationCreatePayloadBuilder', () {
    test('builds one-off payload with creationDate', () {
      final body = ExternalDonationCreatePayloadBuilder.build(
        const ExternalDonationCreateDraft(
          organisationName: 'Red Cross',
          amountInput: '25',
          isOneOff: true,
          dateMade: null,
          isCustomOrganisation: true,
          taxDeductible: true,
        ).copyWith(
          dateMade: DateTime(2024, 3, 15),
        ),
      );

      expect(body['amount'], 25.0);
      expect(body['description'], 'Red Cross');
      expect(body['frequency'], 'Once');
      expect(body['taxDeductable'], isTrue);
      expect(body['creationDate'], isNotNull);
      expect(body.containsKey('startDate'), isFalse);
    });

    test('builds recurring payload with startDate and last gift anchor', () {
      final body = ExternalDonationCreatePayloadBuilder.build(
        ExternalDonationCreateDraft(
          organisationName: 'WWF',
          amountInput: '10',
          isOneOff: false,
          frequency: ExternalDonationFrequency.monthly,
          lastGiftDate: DateTime(2024, 6, 12),
          startMonthYear: DateTime(2024, 1),
          selectedOrganisation: null,
          isCustomOrganisation: false,
        ),
      );

      expect(body['frequency'], 'Monthly');
      expect(body['startDate'], isNotNull);
      expect(body['creationDate'], isNotNull);
      expect(body['taxDeductable'], isFalse);
    });
  });

  group('generateOccurrencePreview', () {
    test('includes past occurrences and one upcoming for monthly series', () {
      final preview = generateOccurrencePreview(
        startMonthYear: DateTime(2024, 1),
        lastGiftDate: DateTime(2024, 3, 12),
        frequency: ExternalDonationFrequency.monthly,
        now: DateTime(2024, 3, 12),
      );

      expect(preview, isNotEmpty);
      expect(preview.length, greaterThan(1));
      expect(preview.first.month, 1);
      expect(preview.any((date) => date.day == 12), isTrue);
    });

    test('includes months through today when last gift is earlier', () {
      final preview = generateOccurrencePreview(
        startMonthYear: DateTime(2026, 3),
        lastGiftDate: DateTime(2026, 3, 1),
        frequency: ExternalDonationFrequency.monthly,
        now: DateTime(2026, 5, 30),
      );

      expect(
        preview,
        [
          DateTime(2026, 3, 1),
          DateTime(2026, 4, 1),
          DateTime(2026, 5, 1),
          DateTime(2026, 6, 1),
        ],
      );
    });

    test('appends next monthly occurrence after last gift in same month', () {
      final preview = generateOccurrencePreview(
        startMonthYear: DateTime(2026, 5),
        lastGiftDate: DateTime(2026, 5, 1),
        frequency: ExternalDonationFrequency.monthly,
        now: DateTime(2026, 5, 30),
      );

      expect(preview.last, DateTime(2026, 6, 1));
    });

    test('supports weekly frequency', () {
      final preview = generateOccurrencePreview(
        startMonthYear: DateTime(2023, 10),
        lastGiftDate: DateTime(2024, 1, 21),
        frequency: ExternalDonationFrequency.weekly,
        now: DateTime(2024, 1, 21),
      );

      expect(preview.length, greaterThan(2));
    });
  });
}
