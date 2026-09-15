import 'dart:async';

import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/donation_overview/models/models.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

mixin DonationOverviewRepository {
  Stream<List<DonationItem>> onDonationsChanged();
  List<DonationItem> getDonations();
  bool isLoading();
  String? getError();
  Future<void> loadDonations({DateTime? startDate, DateTime? endDate});
  Future<bool> deleteDonation(List<int> ids);
  Future<bool> downloadYearlyOverview({
    required String fromDate,
    required String toDate,
  });
}

class DonationOverviewRepositoryImpl with DonationOverviewRepository {
  DonationOverviewRepositoryImpl(
    this._givtRepository,
    this._collectGroupRepository,
  );

  final GivtRepository _givtRepository;
  final CollectGroupRepository _collectGroupRepository;
  final StreamController<List<DonationItem>> _donationsController =
      StreamController<List<DonationItem>>.broadcast();

  List<DonationItem> _donations = [];
  bool _isLoading = false;
  String? _error;

  @override
  Stream<List<DonationItem>> onDonationsChanged() {
    return _donationsController.stream;
  }

  @override
  List<DonationItem> getDonations() {
    return _donations;
  }

  @override
  bool isLoading() {
    return _isLoading;
  }

  @override
  String? getError() {
    return _error;
  }

  @override
  Future<void> loadDonations({DateTime? startDate, DateTime? endDate}) async {
    try {
      _isLoading = true;
      _error = null;
      _emitDonationsChanged();

      final fetched = List<DonationItem>.of(
        await _givtRepository.fetchDonationHistory(
          startDate: startDate,
          endDate: endDate,
        ),
      );

      _donations = await _withResolvedOrganisationNames(fetched);

      _donations.sort((a, b) {
        if (a.timeStamp == null && b.timeStamp == null) return 0;
        if (a.timeStamp == null) return 1;
        if (b.timeStamp == null) return -1;
        return b.timeStamp!.compareTo(a.timeStamp!);
      });

      _isLoading = false;
      _emitDonationsChanged();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _emitDonationsChanged();
      // Rethrow so DonationOverviewCubit can emit error UI (Retry).
      // Swallowing here painted the empty-history screen for 4xx/5xx.
      rethrow;
    }
  }

  @override
  Future<bool> deleteDonation(List<int> ids) async {
    try {
      final result = await _givtRepository.deleteGivt(ids);
      if (result) {
        _donations.removeWhere((donation) => ids.contains(donation.id));
        _emitDonationsChanged();
      }
      return result;
    } catch (e) {
      _error = e.toString();
      _emitDonationsChanged();
      return false;
    }
  }

  @override
  Future<bool> downloadYearlyOverview({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final result = await _givtRepository.downloadYearlyOverview(
        fromDate: fromDate,
        toDate: toDate,
      );
      return result;
    } catch (e) {
      _error = e.toString();
      _emitDonationsChanged();
      return false;
    }
  }

  Future<List<DonationItem>> _withResolvedOrganisationNames(
    List<DonationItem> donations,
  ) async {
    final needsLookup = donations.any(
      (donation) =>
          !donation.isExternal &&
          donation.organisationName.trim().isEmpty &&
          donation.mediumId.trim().isNotEmpty,
    );
    if (!needsLookup) {
      return donations;
    }

    final collectGroups = await _collectGroupsForNameLookup();
    return DonationOrganisationNameResolver.fillMissingNames(
      donations,
      collectGroups,
    );
  }

  Future<List<CollectGroup>> _collectGroupsForNameLookup() async {
    try {
      var collectGroups = await _collectGroupRepository.getCollectGroupList();
      if (collectGroups.isEmpty) {
        collectGroups = await _collectGroupRepository.fetchCollectGroupList();
      }
      return collectGroups;
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load collect groups for organisation names: $error',
        methodName:
            'DonationOverviewRepositoryImpl._collectGroupsForNameLookup',
      );
      return const [];
    }
  }

  void _emitDonationsChanged() {
    if (!_donationsController.isClosed) {
      _donationsController.add(_donations);
    }
  }

  void dispose() {
    _donationsController.close();
  }
}
