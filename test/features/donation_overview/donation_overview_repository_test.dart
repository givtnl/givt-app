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
  }) async =>
      const [];

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
      final repository = DonationOverviewRepositoryImpl(
        _EmptyGivtRepository(),
      );

      await repository.loadDonations();

      expect(repository.getDonations(), isEmpty);
      expect(repository.getError(), isNull);
      expect(repository.isLoading(), isFalse);
    });
  });
}
