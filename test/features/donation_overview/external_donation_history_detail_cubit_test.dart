import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/donation_overview/cubit/external_donation_history_detail_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_mapper.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

class _FakeGivtRepository with GivtRepository {
  bool updateResult = true;
  double? lastUpdatedAmount;
  String? lastUpdatedStartDate;
  List<ExternalDonation> donations = const [];
  int fetchExternalDonationsCalls = 0;
  int fetchExternalDonationDetailCalls = 0;

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
  Future<List<ExternalDonation>> fetchExternalDonations() async {
    fetchExternalDonationsCalls++;
    return donations;
  }

  @override
  Future<ExternalDonation?> fetchExternalDonationDetail(String id) async {
    fetchExternalDonationDetailCalls++;
    return ExternalDonation(
      id: id,
      amount: 30,
      description: 'Shelter',
      frequencyString: 'Monthly',
      creationDate: '2026-01-01T00:00:00.000Z',
      taxDeductible: false,
      active: false,
    );
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

    test(
      'loadExternalDonationForManage uses list so active recurring stays active',
      () async {
        const listed = ExternalDonation(
          id: 'series-2',
          amount: 30,
          description: 'Shelter',
          frequencyString: 'Monthly',
          creationDate: '2026-01-01T00:00:00.000Z',
          taxDeductible: false,
          active: true,
        );
        repository.donations = [listed];

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

        final donation = await cubit.loadExternalDonationForManage();

        expect(repository.fetchExternalDonationsCalls, 1);
        expect(repository.fetchExternalDonationDetailCalls, 0);
        expect(donation, listed);
        expect(donation?.active, isTrue);
        expect(donation?.isRecurring, isTrue);
      },
    );

    test(
      'loadExternalDonationForManage returns null when series is not listed',
      () async {
        repository.donations = const [];

        final donation = await cubit.loadExternalDonationForManage();

        expect(donation, isNull);
        expect(repository.fetchExternalDonationDetailCalls, 0);
      },
    );
  });
}
