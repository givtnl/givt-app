import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
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
  }) async => const [];

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
    return const [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('DonationOverviewRepositoryImpl.loadDonations', () {
    test('rethrows fetch failures so the cubit can show Retry', () async {
      final repository = DonationOverviewRepositoryImpl(
        _ThrowingGivtRepository(),
      );

      await expectLater(
        repository.loadDonations(),
        throwsA(isA<GivtServerFailure>()),
      );
      expect(repository.getDonations(), isEmpty);
      expect(repository.getError(), isNotNull);
      expect(repository.isLoading(), isFalse);
    });

    test('keeps a successful empty list as empty data, not an error', () async {
      final repository = DonationOverviewRepositoryImpl(_EmptyGivtRepository());

      await repository.loadDonations();

      expect(repository.getDonations(), isEmpty);
      expect(repository.getError(), isNull);
      expect(repository.isLoading(), isFalse);
    });

    test('forwards start and end dates to the donation history API', () async {
      final givtRepository = _CapturingGivtRepository();
      final repository = DonationOverviewRepositoryImpl(givtRepository);
      final start = DateTime(2026, 9);
      final end = DateTime(2026, 9, 12, 23, 59, 59, 999);

      await repository.loadDonations(startDate: start, endDate: end);

      expect(givtRepository.startDate, start);
      expect(givtRepository.endDate, end);
    });
  });
}
