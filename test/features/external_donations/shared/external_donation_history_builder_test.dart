import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_history_builder.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_transaction.dart';

void main() {
  group('ExternalDonationHistoryBuilder', () {
    test('builds placeholder from startDate when there are no transactions', () {
      final donation = ExternalDonation.fromJson({
        'id': 'donation-1',
        'amount': 10,
        'description': 'Charity',
        'frequency': 'Monthly',
        'creationDate': '2024-06-01T00:00:00.000Z',
        'startDate': '2024-01-15T00:00:00.000Z',
        'taxDeductable': false,
        'active': true,
      });

      final detail = ExternalDonationHistoryBuilder.build(
        donation: donation,
        transactions: const [],
        now: DateTime(2024, 6, 1),
      );

      expect(detail.totalDonated, 10);
      expect(detail.history, hasLength(2));
      expect(detail.history.last.date, donation.startDateTime);
    });

    test('skips future transactions', () {
      final donation = ExternalDonation.fromJson({
        'id': 'donation-1',
        'amount': 10,
        'description': 'Charity',
        'frequency': 'Monthly',
        'creationDate': '2024-01-01T00:00:00.000Z',
        'startDate': '2024-01-01T00:00:00.000Z',
        'taxDeductable': false,
        'active': true,
      });

      final detail = ExternalDonationHistoryBuilder.build(
        donation: donation,
        transactions: [
          ExternalDonationTransaction.fromJson({
            'id': 'tx-1',
            'amount': 10,
            'creationDate': '2025-01-01T00:00:00.000Z',
          }),
        ],
        now: DateTime(2024, 6, 1),
      );

      final recorded = detail.history.where((item) => !item.isUpcoming);
      expect(recorded.every((item) => item.date.year != 2025), isTrue);
    });
  });
}
