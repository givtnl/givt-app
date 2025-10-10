import 'dart:async';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';

mixin RecurringDonationsOverviewRepository {
  Stream<List<RecurringDonation>> onRecurringDonationsChanged();
  List<RecurringDonation> getRecurringDonations();
  bool isLoading();
  String? getError();
  Future<void> loadRecurringDonations({String status = 'active'});
}

class RecurringDonationsOverviewRepositoryImpl
    with RecurringDonationsOverviewRepository {
  RecurringDonationsOverviewRepositoryImpl(
    this.apiService,
  );

  final APIService apiService;
  final StreamController<List<RecurringDonation>> _donationsController =
      StreamController<List<RecurringDonation>>.broadcast();

  List<RecurringDonation> _donations = [];
  bool _isLoading = false;
  String? _error;

  @override
  Stream<List<RecurringDonation>> onRecurringDonationsChanged() {
    return _donationsController.stream;
  }

  @override
  List<RecurringDonation> getRecurringDonations() {
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
  Future<void> loadRecurringDonations({String status = 'active'}) async {
    _isLoading = true;
    _error = null;
    _donationsController.add(_donations);

    try {
      final response = await apiService.fetchRecurringDonations(
        status: status,
      );

      final result = <RecurringDonation>[];
      for (final item in response) {
        result.add(RecurringDonation.fromJson(item as Map<String, dynamic>));
      }

      _donations = result;
      _error = null;
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      _donationsController.add(_donations);
    }
  }

  void dispose() {
    _donationsController.close();
  }
}
