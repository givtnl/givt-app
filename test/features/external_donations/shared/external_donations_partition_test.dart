import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/shared/external_donations_partition.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';

void main() {
  group('ExternalDonationsPartition', () {
    const activeMonthly = ExternalDonation(
      id: '1',
      amount: 10,
      description: 'Charity A',
      frequencyString: 'Monthly',
      creationDate: '2024-01-01T00:00:00.000Z',
      taxDeductible: false,
      active: true,
    );

    const stoppedMonthly = ExternalDonation(
      id: '2',
      amount: 20,
      description: 'Charity B',
      frequencyString: 'Monthly',
      creationDate: '2023-06-01T00:00:00.000Z',
      taxDeductible: false,
      active: false,
    );

    const oneOff = ExternalDonation(
      id: '3',
      amount: 50,
      description: 'Charity C',
      frequencyString: 'Once',
      creationDate: '2024-03-01T00:00:00.000Z',
      taxDeductible: true,
      active: true,
    );

    test('splits current and past donations', () {
      final donations = [activeMonthly, stoppedMonthly, oneOff];

      final current = ExternalDonationsPartition.current(donations);
      final past = ExternalDonationsPartition.past(donations);

      expect(current, [activeMonthly]);
      expect(past, [oneOff, stoppedMonthly]);
    });

    test('returns empty lists when there are no donations', () {
      expect(ExternalDonationsPartition.current(const []), isEmpty);
      expect(ExternalDonationsPartition.past(const []), isEmpty);
    });
  });
}
