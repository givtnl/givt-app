import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';

void main() {
  group('ExternalDonation', () {
    test('fromJson parses nextRecurringDate', () {
      final donation = ExternalDonation.fromJson({
        'id': 'donation-1',
        'amount': 25,
        'description': 'Charity',
        'frequency': 'Monthly',
        'creationDate': '2024-01-01T00:00:00.000Z',
        'taxDeductable': false,
        'active': true,
        'nextRecurringDate': '2024-06-01T00:00:00.000Z',
      });

      expect(donation.nextRecurringDate, '2024-06-01T00:00:00.000Z');
      expect(
        donation.nextRecurringOccurrenceDate,
        DateTime.parse('2024-06-01T00:00:00.000Z').toLocal(),
      );
    });

    test('fromJson parses startDate and startDateTime in local time', () {
      final donation = ExternalDonation.fromJson({
        'id': 'donation-1',
        'amount': 25,
        'description': 'Charity',
        'frequency': 'Once',
        'creationDate': '2024-06-15T00:00:00.000Z',
        'startDate': '2026-05-30T18:50:17.5669885+00:00',
        'taxDeductable': false,
      });

      expect(donation.startDate, '2026-05-30T18:50:17.5669885+00:00');
      expect(
        donation.startDateTime,
        DateTime.parse('2026-05-30T18:50:17.5669885+00:00').toLocal(),
      );
    });

    test('startDateTime is null when startDate is absent', () {
      final donation = ExternalDonation.fromJson({
        'id': 'donation-1',
        'amount': 25,
        'description': 'Charity',
        'frequency': 'Once',
        'creationDate': '2024-01-01T00:00:00.000Z',
        'taxDeductable': false,
      });

      expect(donation.startDate, isNull);
      expect(donation.startDateTime, isNull);
    });

    test('nextRecurringOccurrenceDate is null when field is absent', () {
      final donation = ExternalDonation.fromJson({
        'id': 'donation-1',
        'amount': 25,
        'description': 'Charity',
        'frequency': 'Monthly',
        'creationDate': '2024-01-01T00:00:00.000Z',
        'taxDeductable': false,
      });

      expect(donation.nextRecurringOccurrenceDate, isNull);
    });
  });
}
