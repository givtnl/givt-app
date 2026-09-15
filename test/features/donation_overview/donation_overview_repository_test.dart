import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_mapper.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

class _ThrowingGivtRepository with GivtRepository {
  @override
  Future<List<DonationItem>> fetchDonationHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    throw const GivtServerFailure(statusCode: 500, body: null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _EmptyGivtRepository with GivtRepository {
  @override
  Future<List<DonationItem>> fetchDonationHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async => <DonationItem>[];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _CapturingGivtRepository with GivtRepository {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Future<List<DonationItem>> fetchDonationHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    this.startDate = startDate;
    this.endDate = endDate;
    return <DonationItem>[];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _HistoryGivtRepository with GivtRepository {
  _HistoryGivtRepository(this._items);

  final List<DonationItem> _items;

  @override
  Future<List<DonationItem>> fetchDonationHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async => _items;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCollectGroupRepository with CollectGroupRepository {
  _FakeCollectGroupRepository(this._groups);

  final List<CollectGroup> _groups;

  @override
  Future<List<CollectGroup>> fetchCollectGroupList() async => _groups;

  @override
  Future<List<CollectGroup>> getCollectGroupList() async => _groups;
}

DonationOverviewRepositoryImpl _repository(
  GivtRepository givtRepository, [
  List<CollectGroup> collectGroups = const [],
]) {
  return DonationOverviewRepositoryImpl(
    givtRepository,
    _FakeCollectGroupRepository(collectGroups),
  );
}

void main() {
  group('DonationOverviewRepositoryImpl.loadDonations', () {
    test('rethrows fetch failures so the cubit can show Retry', () async {
      final repository = _repository(_ThrowingGivtRepository());

      await expectLater(
        repository.loadDonations(),
        throwsA(isA<GivtServerFailure>()),
      );
      expect(repository.getDonations(), isEmpty);
      expect(repository.getError(), isNotNull);
      expect(repository.isLoading(), isFalse);
    });

    test('keeps a successful empty list as empty data, not an error', () async {
      final repository = _repository(_EmptyGivtRepository());

      await repository.loadDonations();

      expect(repository.getDonations(), isEmpty);
      expect(repository.getError(), isNull);
      expect(repository.isLoading(), isFalse);
    });

    test('forwards start and end dates to the donation history API', () async {
      final givtRepository = _CapturingGivtRepository();
      final repository = _repository(givtRepository);
      final start = DateTime(2026, 9);
      final end = DateTime(2026, 9, 12, 23, 59, 59, 999);

      await repository.loadDonations(startDate: start, endDate: end);

      expect(givtRepository.startDate, start);
      expect(givtRepository.endDate, end);
    });

    test('fills blank organisation names from collect groups', () async {
      final donation = DonationHistoryMapper.fromHistoryJson({
        'source': 'givtProcessed',
        'id': '1',
        'amount': 5,
        'timestamp': '2026-03-15T10:00:00',
        'organisationName': '',
        'mediumId': 'ns-church.c1',
        'collectId': 1,
      });
      final repository = _repository(
        _HistoryGivtRepository([donation]),
        [
          const CollectGroup(
            nameSpace: 'ns-church',
            orgName: 'Achterlandkerk',
            hasCelebration: false,
            type: CollectGroupType.church,
          ),
        ],
      );

      await repository.loadDonations();

      expect(
        repository.getDonations().single.organisationName,
        'Achterlandkerk',
      );
    });
  });
}
