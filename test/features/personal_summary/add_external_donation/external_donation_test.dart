import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';

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
        DateTime.parse('2024-06-01T00:00:00.000Z'),
      );
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
