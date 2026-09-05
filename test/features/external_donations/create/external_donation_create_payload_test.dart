import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_draft.dart';
import 'package:givt_app/features/external_donations/create/repositories/external_donation_create_repository.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';

void main() {
  group('ExternalDonationCreatePayloadBuilder', () {
    test('builds one-off payload without creationDate', () {
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
      expect(body.containsKey('creationDate'), isFalse);
      expect(body['startDate'], '2024-03-15T00:00:00.000');
      expect((body['startDate'] as String).endsWith('Z'), isFalse);
      expect(body.containsKey('active'), isFalse);
      expect(body.containsKey('collectGroupId'), isFalse);
    });

    test(
      'builds recurring payload with startDate from first donation date',
      () {
        final body = ExternalDonationCreatePayloadBuilder.build(
          ExternalDonationCreateDraft(
            organisationName: 'WWF',
            amountInput: '10',
            isOneOff: false,
            frequency: ExternalDonationFrequency.monthly,
            seriesStartDate: DateTime(2024, 1, 12),
            selectedOrganisation: null,
            isCustomOrganisation: false,
          ),
        );

        expect(body['frequency'], 'Monthly');
        expect(body['startDate'], '2024-01-12T00:00:00.000');
        expect((body['startDate'] as String).endsWith('Z'), isFalse);
        expect(body.containsKey('creationDate'), isFalse);
        expect(body['taxDeductable'], isFalse);
        expect(body.containsKey('active'), isFalse);
        expect(body.containsKey('collectGroupId'), isFalse);
      },
    );

    test('builds recurring payload with Quarterly frequency', () {
      final body = ExternalDonationCreatePayloadBuilder.build(
        ExternalDonationCreateDraft(
          organisationName: 'WWF',
          amountInput: '10',
          isOneOff: false,
          frequency: ExternalDonationFrequency.quarterly,
          seriesStartDate: DateTime(2024, 1, 12),
          selectedOrganisation: null,
          isCustomOrganisation: false,
        ),
      );

      expect(body['frequency'], 'Quarterly');
      expect(body['startDate'], '2024-01-12T00:00:00.000');
    });
  });

  group('generateOccurrencePreview', () {
    test('includes past occurrences and one upcoming for monthly series', () {
      final preview = generateOccurrencePreview(
        seriesStartDate: DateTime(2024, 1, 12),
        frequency: ExternalDonationFrequency.monthly,
        now: DateTime(2024, 3, 12),
      );

      expect(preview, isNotEmpty);
      expect(preview.length, greaterThan(1));
      expect(preview.first, DateTime(2024, 1, 12));
      expect(preview.any((date) => date.day == 12), isTrue);
    });

    test('includes months through today from series start', () {
      final preview = generateOccurrencePreview(
        seriesStartDate: DateTime(2026, 3, 1),
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

    test('appends next monthly occurrence after last past in same month', () {
      final preview = generateOccurrencePreview(
        seriesStartDate: DateTime(2026, 5, 1),
        frequency: ExternalDonationFrequency.monthly,
        now: DateTime(2026, 5, 30),
      );

      expect(preview.last, DateTime(2026, 6, 1));
    });

    test('supports weekly frequency', () {
      final preview = generateOccurrencePreview(
        seriesStartDate: DateTime(2024, 1, 21),
        frequency: ExternalDonationFrequency.weekly,
        now: DateTime(2024, 2, 4),
      );

      expect(preview.length, greaterThan(2));
    });

    test('supports quarterly frequency with next occurrence', () {
      final preview = generateOccurrencePreview(
        seriesStartDate: DateTime(2024, 1, 12),
        frequency: ExternalDonationFrequency.quarterly,
        now: DateTime(2024, 7, 12),
      );

      expect(
        preview,
        [
          DateTime(2024, 1, 12),
          DateTime(2024, 4, 12),
          DateTime(2024, 7, 12),
          DateTime(2024, 10, 12),
        ],
      );
    });
  });
}
