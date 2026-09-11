import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_mapper.dart';
import 'package:givt_app/features/donation_overview/models/donation_overview_uimodel.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';

void main() {
  group('DonationHistoryMapper', () {
    test('maps givt-processed rows with legacy status fields', () {
      final item = DonationHistoryMapper.fromHistoryJson({
        'source': 'givtProcessed',
        'id': '42',
        'amount': 12.5,
        'timestamp': '2026-03-15T10:30:00',
        'organisationName': 'Hope Church',
        'status': 2,
        'collectId': 1,
        'allocationName': 'General fund',
        'giftAidEnabled': true,
        'donationType': 1,
        'mediumId': 'coin-1',
      });

      expect(item.isExternal, isFalse);
      expect(item.id, 42);
      expect(item.organisationName, 'Hope Church');
      expect(item.isGiftAidEnabled, isTrue);
      expect(item.donationType, 1);
      expect(item.status.type, DonationStatusType.completed);
    });

    test('maps external recurring rows with frequency', () {
      final item = DonationHistoryMapper.fromHistoryJson({
        'source': 'external',
        'id': 'tx-1',
        'externalDonationId': 'series-1',
        'externalTransactionId': 'tx-1',
        'amount': 20,
        'timestamp': '2026-03-10T09:00:00',
        'organisationName': 'Local Food Bank',
        'frequency': 'Monthly',
        'isRecurring': true,
      });

      expect(item.isExternal, isTrue);
      expect(item.externalDonationId, 'series-1');
      expect(item.externalTransactionId, 'tx-1');
      expect(item.externalFrequency, ExternalDonationFrequency.monthly);
      expect(item.isExternalRecurring, isTrue);
    });
  });

  group('DonationOverviewUIModel grouping', () {
    test('keeps givt grouping by timestamp and organisation', () {
      final timestamp = DateTime(2026, 3, 15, 10);
      final donations = [
        DonationHistoryMapper.fromHistoryJson({
          'source': 'givtProcessed',
          'id': '1',
          'amount': 5,
          'timestamp': timestamp.toIso8601String(),
          'organisationName': 'Hope Church',
          'status': 2,
          'collectId': 1,
        }),
        DonationHistoryMapper.fromHistoryJson({
          'source': 'givtProcessed',
          'id': '2',
          'amount': 7,
          'timestamp': timestamp.toIso8601String(),
          'organisationName': 'Hope Church',
          'status': 2,
          'collectId': 2,
        }),
      ];

      final uiModel = DonationOverviewUIModel.fromDonations(donations);

      expect(uiModel.donationGroups, hasLength(1));
      expect(uiModel.donationGroups.first.donations, hasLength(2));
      expect(uiModel.donationGroups.first.isExternal, isFalse);
    });

    test('does not merge external rows and includes them in month totals', () {
      final donations = [
        DonationHistoryMapper.fromHistoryJson({
          'source': 'external',
          'id': 'tx-1',
          'externalDonationId': 'series-1',
          'externalTransactionId': 'tx-1',
          'amount': 15,
          'timestamp': '2026-03-10T09:00:00',
          'organisationName': 'Food Bank',
          'frequency': 'Once',
          'isRecurring': false,
        }),
        DonationHistoryMapper.fromHistoryJson({
          'source': 'external',
          'id': 'tx-2',
          'externalDonationId': 'series-2',
          'externalTransactionId': 'tx-2',
          'amount': 25,
          'timestamp': '2026-03-10T18:00:00',
          'organisationName': 'Food Bank',
          'frequency': 'Monthly',
          'isRecurring': true,
        }),
        DonationHistoryMapper.fromHistoryJson({
          'source': 'givtProcessed',
          'id': '9',
          'amount': 10,
          'timestamp': '2026-03-10T12:00:00',
          'organisationName': 'Food Bank',
          'status': 2,
        }),
      ];

      final uiModel = DonationOverviewUIModel.fromDonations(donations);

      expect(uiModel.donationGroups, hasLength(3));
      expect(
        uiModel.donationGroups.where((group) => group.isExternal),
        hasLength(2),
      );
      expect(uiModel.monthlyGroups.single.totalAmount, 50);
      expect(uiModel.giftAidAmount, 0);
      expect(
        uiModel.donationGroups
            .firstWhere((group) => group.isRecurringDonation)
            .isExternal,
        isTrue,
      );
    });
  });
}
