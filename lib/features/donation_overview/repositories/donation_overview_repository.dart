import 'dart:async';

import 'package:givt_app/features/donation_overview/models/models.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

mixin DonationOverviewRepository {
  Stream<List<DonationItem>> onDonationsChanged();
  List<DonationItem> getDonations();
  bool isLoading();
  String? getError();
  Future<void> loadDonations();
  Future<bool> deleteDonation(List<int> ids);
  Future<bool> downloadYearlyOverview({
    required String fromDate,
    required String toDate,
  });
}

class DonationOverviewRepositoryImpl with DonationOverviewRepository {
  DonationOverviewRepositoryImpl(this._givtRepository);

  final GivtRepository _givtRepository;
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
  Future<void> loadDonations() async {
    try {
      _isLoading = true;
      _error = null;
      _emitDonationsChanged();

      final givts = await _givtRepository.fetchGivts();
      _donations = givts.map((givt) => DonationItem.fromGivt(givt)).toList();
      
      // Sort donations by timestamp (newest first)
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
    }
  }

  @override
  Future<bool> deleteDonation(List<int> ids) async {
    try {
      final result = await _givtRepository.deleteGivt(ids);
      if (result) {
        // Remove deleted donations from local list
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

  void _emitDonationsChanged() {
    if (!_donationsController.isClosed) {
      _donationsController.add(_donations);
    }
  }

  void dispose() {
    _donationsController.close();
  }
}
