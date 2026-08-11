import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/create/repository/recurring_donation_repository.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart'
    as overview;
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

class _FakeCollectGroupRepository with CollectGroupRepository {
  _FakeCollectGroupRepository(this.collectGroups);

  final List<CollectGroup> collectGroups;

  @override
  Future<List<CollectGroup>> fetchCollectGroupList() async => collectGroups;

  @override
  Future<List<CollectGroup>> getCollectGroupList() async => collectGroups;
}

class _FakeNetworkInfo with NetworkInfo {
  @override
  bool get isConnected => true;

  @override
  Stream<bool> hasInternetConnectionStream() => const Stream.empty();
}

class _FakeApiService extends APIService {
  _FakeApiService(RequestHelper requestHelper) : super(requestHelper);
}

void main() {
  group('RecurringDonationRepository.initFromRecurringDonation', () {
    const collectGroup = CollectGroup(
      nameSpace: 'org.namespace',
      orgName: 'Test Church',
      hasCelebration: false,
      type: CollectGroupType.church,
    );

    late RecurringDonationRepository repository;
    late _FakeApiService apiService;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final requestHelper = RequestHelper(
        _FakeNetworkInfo(),
        prefs,
        apiURL: 'api.example.com',
      );
      apiService = _FakeApiService(requestHelper);
      repository = RecurringDonationRepository(
        _FakeCollectGroupRepository([collectGroup]),
        apiService,
      );
    });

    overview.RecurringDonation buildDonation({
      int numberOfTurns = 12,
      String? endDate,
      double amount = 10,
    }) {
      return overview.RecurringDonation(
        id: 'donation-1',
        userId: 'user-1',
        amount: amount,
        frequency: overview.Frequency.monthly,
        numberOfTurns: numberOfTurns,
        startDate: '2024-01-01T00:00:00.000Z',
        endDate: endDate,
        currentState: overview.RecurringDonationState.finished,
        creationDateTime: '2024-01-01T00:00:00.000Z',
        collectGroupName: collectGroup.orgName,
      );
    }

    test(
      'prefills draft with tomorrow as start date and fixed turns',
      () async {
        await repository.initFromRecurringDonation(
          donation: buildDonation(),
          guid: 'guid-1',
          country: 'NL',
        );

        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final expectedStartDate = DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
        );

        expect(repository.selectedOrganization, collectGroup);
        expect(repository.frequency, overview.Frequency.monthly);
        expect(repository.amount, '10');
        expect(repository.startDate, expectedStartDate);
        expect(
          repository.selectedEndOption,
          RecurringDonationStringKeys.afterNumberOfDonations,
        );
        expect(repository.numberOfDonations, '12');
        expect(repository.guid, 'guid-1');
        expect(repository.country, 'NL');
      },
    );

    test('maps unlimited donations to when I decide', () async {
      await repository.initFromRecurringDonation(
        donation: buildDonation(numberOfTurns: 999),
        guid: 'guid-1',
        country: 'NL',
      );

      expect(
        repository.selectedEndOption,
        RecurringDonationStringKeys.whenIDecide,
      );
      expect(repository.numberOfDonations, isNull);
      expect(repository.endDate, isNull);
    });

    test('maps future end date donations to on specific date', () async {
      final futureEndDate = DateTime.now().add(const Duration(days: 30));
      await repository.initFromRecurringDonation(
        donation: buildDonation(
          numberOfTurns: 6,
          endDate: futureEndDate.toIso8601String(),
        ),
        guid: 'guid-1',
        country: 'NL',
      );

      expect(
        repository.selectedEndOption,
        RecurringDonationStringKeys.onSpecificDate,
      );
      expect(repository.endDate, futureEndDate);
    });

    test('maps past end date donations to number of donations', () async {
      await repository.initFromRecurringDonation(
        donation: buildDonation(
          numberOfTurns: 6,
          endDate: '2020-01-01T00:00:00.000Z',
        ),
        guid: 'guid-1',
        country: 'NL',
      );

      expect(
        repository.selectedEndOption,
        RecurringDonationStringKeys.afterNumberOfDonations,
      );
      expect(repository.numberOfDonations, '6');
      expect(repository.endDate, isNull);
    });

    test('throws when organization cannot be resolved', () async {
      repository = RecurringDonationRepository(
        _FakeCollectGroupRepository(const []),
        apiService,
      );

      expect(
        () => repository.initFromRecurringDonation(
          donation: buildDonation(),
          guid: 'guid-1',
          country: 'NL',
        ),
        throwsA(isA<OrganisationNotFoundException>()),
      );
    });

    test(
      'throws InactiveOrganisationException when organization is inactive',
      () async {
        const inactiveCollectGroup = CollectGroup(
          nameSpace: 'org.namespace',
          orgName: 'Test Church',
          hasCelebration: false,
          type: CollectGroupType.church,
          isActive: false,
        );
        repository = RecurringDonationRepository(
          _FakeCollectGroupRepository([inactiveCollectGroup]),
          apiService,
        );

        expect(
          () => repository.initFromRecurringDonation(
            donation: buildDonation(),
            guid: 'guid-1',
            country: 'NL',
          ),
          throwsA(isA<InactiveOrganisationException>()),
        );
      },
    );
  });
}
