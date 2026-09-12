import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/donation_overview/cubit/external_donation_history_detail_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_mapper.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

class _FakeGivtRepository with GivtRepository {
  bool updateResult = true;
  double? lastUpdatedAmount;
  String? lastUpdatedStartDate;

  @override
  Future<bool> updateExternalDonation({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    lastUpdatedAmount = (body['amount'] as num?)?.toDouble();
    lastUpdatedStartDate = body['startDate'] as String?;
    return updateResult;
  }

  @override
  Future<bool> bulkUpdateExternalDonationTransactions({
    required List<String> transactionIds,
    required double newAmount,
  }) async {
    lastUpdatedAmount = newAmount;
    return updateResult;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ExternalDonationHistoryDetailCubit', () {
    late _FakeGivtRepository repository;
    late ExternalDonationHistoryDetailCubit cubit;

    final initialDonation = DonationHistoryMapper.fromHistoryJson({
      'source': 'external',
      'id': 'tx-1',
      'externalDonationId': 'series-1',
      'externalTransactionId': 'tx-1',
      'amount': 20,
      'timestamp': '2026-03-10T09:00:00',
      'organisationName': 'Food Bank',
      'frequency': 'Once',
      'isRecurring': false,
    });

    setUp(() {
      repository = _FakeGivtRepository();
      cubit = ExternalDonationHistoryDetailCubit(repository);
      cubit.init(initialDonation);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('updateOneOffAmount keeps updated amount after mutation completes',
        () async {
      await cubit.updateOneOffAmount(35);

      expect(repository.lastUpdatedAmount, 35);
      final state =
          cubit.state as DataState<ExternalDonationHistoryDetailUIModel,
              ExternalDonationHistoryDetailCustom>;
      expect(state.data.donation.amount, 35);
      expect(state.data.isSaving, isFalse);
    });

    test('updateOneOffDate keeps updated date after mutation completes',
        () async {
      final newDate = DateTime(2026, 4, 15);

      await cubit.updateOneOffDate(newDate);

      expect(repository.lastUpdatedStartDate, '2026-04-15T00:00:00.000');
      final state =
          cubit.state as DataState<ExternalDonationHistoryDetailUIModel,
              ExternalDonationHistoryDetailCustom>;
      expect(state.data.donation.timeStamp, newDate);
      expect(state.data.isSaving, isFalse);
    });

    test('updateOccurrenceAmount keeps updated amount after mutation completes',
        () async {
      final recurringDonation = DonationHistoryMapper.fromHistoryJson({
        'source': 'external',
        'id': 'tx-2',
        'externalDonationId': 'series-2',
        'externalTransactionId': 'tx-2',
        'amount': 30,
        'timestamp': '2026-03-11T09:00:00',
        'organisationName': 'Shelter',
        'frequency': 'Monthly',
        'isRecurring': true,
      });
      cubit.init(recurringDonation);

      await cubit.updateOccurrenceAmount(45);

      expect(repository.lastUpdatedAmount, 45);
      final state =
          cubit.state as DataState<ExternalDonationHistoryDetailUIModel,
              ExternalDonationHistoryDetailCustom>;
      expect(state.data.donation.amount, 45);
      expect(state.data.isSaving, isFalse);
    });
  });
}
