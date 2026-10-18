import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_transaction.dart';
import 'package:givt_app/features/give/bloc/give/give_bloc.dart';
import 'package:givt_app/features/give/models/givt_transaction.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/features/give/repositories/beacon_repository.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/givt.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeCampaignRepository campaignRepository;
  late _FakeGivtRepository givtRepository;
  late _FakeBeaconRepository beaconRepository;
  late _FakeCollectGroupRepository collectGroupRepository;
  late GiveBloc bloc;

  const testOrganisation = Organisation(
    organisationName: 'Test Church',
    mediumId: 'namespace.instance',
    collectGroupId: 'cg-1',
    currency: 'EUR',
  );

  const testDonation = GivtTransaction(
    guid: 'user-guid',
    amount: 5,
    beaconId: 'namespace.instance',
    timestamp: '2026-01-01T12:00:00',
    collectId: '1',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    campaignRepository = _FakeCampaignRepository(testOrganisation);
    givtRepository = _FakeGivtRepository();
    beaconRepository = _FakeBeaconRepository();
    collectGroupRepository = _FakeCollectGroupRepository();
    bloc = GiveBloc(
      campaignRepository,
      givtRepository,
      beaconRepository,
      collectGroupRepository,
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  test(
    'For You submit sets submitted when submitGivts succeeds',
    () async {
      bloc.add(
        const GiveForYouSubmitDonations(
          nameSpace: 'namespace.instance',
          userGUID: 'user-guid',
          donations: [testDonation],
        ),
      );

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<GiveState>().having((s) => s.status, 'status', GiveStatus.loading),
          isA<GiveState>()
              .having((s) => s.status, 'status', GiveStatus.readyToGive)
              .having((s) => s.submitted, 'submitted', isTrue),
          isA<GiveState>().having((s) => s.status, 'status', GiveStatus.processed),
        ]),
      );
    },
  );

  test(
    'confirm QR with skipSubmission leaves submitted false',
    () async {
      bloc.emit(
        bloc.state.copyWith(
          status: GiveStatus.readyToConfirm,
          organisation: testOrganisation,
          givtTransactions: [testDonation],
          userGUID: 'user-guid',
          tempAmount: 5,
        ),
      );

      bloc.add(const GiveConfirmQRCodeScannedOutOfApp(skipSubmission: true));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<GiveState>().having((s) => s.status, 'status', GiveStatus.loading),
          isA<GiveState>()
              .having((s) => s.status, 'status', GiveStatus.readyToGive)
              .having((s) => s.submitted, 'submitted', isFalse),
        ]),
      );

      expect(givtRepository.submitCallCount, 0);
    },
  );

  test('amount changed leaves submitted false', () async {
    bloc.emit(
      bloc.state.copyWith(
        status: GiveStatus.readyToGive,
        organisation: testOrganisation,
        userGUID: 'user-guid',
        submitted: false,
      ),
    );

    bloc.add(
      const GiveAmountChanged(
        firstCollectionAmount: 10,
        secondCollectionAmount: 0,
        thirdCollectionAmount: 0,
      ),
    );

    await expectLater(
      bloc.stream,
      emits(
        isA<GiveState>()
            .having((s) => s.status, 'status', GiveStatus.readyToGive)
            .having((s) => s.submitted, 'submitted', isFalse),
      ),
    );
  });

  test('submit transactions sets submitted when submitGivts succeeds', () async {
    bloc.emit(
      bloc.state.copyWith(
        status: GiveStatus.readyToGive,
        organisation: testOrganisation,
        givtTransactions: [testDonation],
        transactionIds: const [],
      ),
    );

    bloc.add(const GiveSubmitTransactions());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<GiveState>().having((s) => s.status, 'status', GiveStatus.loading),
        isA<GiveState>()
            .having((s) => s.status, 'status', GiveStatus.readyToGive)
            .having((s) => s.submitted, 'submitted', isTrue),
      ]),
    );
  });
}

class _FakeCampaignRepository with CampaignRepository {
  _FakeCampaignRepository(this.organisation);

  final Organisation organisation;

  @override
  Future<Organisation> getOrganisation(String mediumId) async => organisation;

  @override
  Future<bool> saveLastDonation(Organisation organisation) async => true;

  @override
  Future<Organisation> getLastOrganisationDonated() async => organisation;

  @override
  Future<Organisation> getCachedOrganisation(String mediumId) async =>
      organisation;
}

class _FakeGivtRepository with GivtRepository {
  int submitCallCount = 0;

  @override
  Stream<void> get offlineQueueChanged => const Stream.empty();

  @override
  List<GivtTransaction> getCachedOfflineGivtTransactions() => const [];

  @override
  Future<void> syncOfflineGivts() async {}

  @override
  Future<List<int>> submitGivts({
    required String guid,
    required Map<String, dynamic> body,
  }) async {
    submitCallCount++;
    return [101];
  }

  @override
  Future<List<Givt>> fetchGivts() => throw UnimplementedError();

  @override
  Future<List<DonationItem>> fetchDonationHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      throw UnimplementedError();

  @override
  Future<List<Pledge>> fetchPledges() => throw UnimplementedError();

  @override
  Future<PledgeGroup> fetchPledgeGroupDetail(String pledgeGroupId) =>
      throw UnimplementedError();

  @override
  Future<List<ExternalDonation>> fetchExternalDonations() =>
      throw UnimplementedError();

  @override
  Future<List<ExternalDonation>> fetchExternalDonationSummary({
    required String fromDate,
    required String tillDate,
  }) =>
      throw UnimplementedError();

  @override
  Future<List<ExternalDonationTransaction>> fetchExternalDonationTransactions(
    String externalDonationId,
  ) =>
      throw UnimplementedError();

  @override
  Future<bool> stopExternalDonation(String id) => throw UnimplementedError();

  @override
  Future<bool> deleteGivt(List<dynamic> ids) => throw UnimplementedError();

  @override
  Future<bool> downloadYearlyOverview({
    required String fromDate,
    required String toDate,
  }) =>
      throw UnimplementedError();

  @override
  Future<ExternalDonation?> addExternalDonation({
    required Map<String, dynamic> body,
  }) =>
      throw UnimplementedError();

  @override
  Future<ExternalDonation?> fetchExternalDonationDetail(String id) =>
      throw UnimplementedError();

  @override
  Future<bool> updateExternalDonation({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      throw UnimplementedError();

  @override
  Future<bool> deleteExternalDonation(String id) => throw UnimplementedError();

  @override
  Future<bool> bulkUpdateExternalDonationTransactions({
    required List<String> transactionIds,
    required double newAmount,
  }) =>
      throw UnimplementedError();

  @override
  Future<bool> bulkDeleteExternalDonationTransactions({
    required List<String> transactionIds,
  }) =>
      throw UnimplementedError();

  @override
  Future<List<SummaryItem>> fetchSummary({
    required String guid,
    required String fromDate,
    required String tillDate,
    required String orderType,
    required String groupType,
  }) =>
      throw UnimplementedError();
}

class _FakeBeaconRepository with BeaconRepository {
  @override
  Future<bool> sendBeaconBatteryStatus({
    required String guid,
    required String beaconId,
    required int batteryVoltage,
  }) async =>
      true;
}

class _FakeCollectGroupRepository with CollectGroupRepository {
  @override
  Future<List<CollectGroup>> fetchCollectGroupList() async => const [];

  @override
  Future<List<CollectGroup>> getCollectGroupList() async => const [];
}
