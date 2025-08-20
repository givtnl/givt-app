import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

mixin RecurringDonationsOverviewRepository {
  Stream<List<RecurringDonation>> onRecurringDonationsChanged();
  List<RecurringDonation> getRecurringDonations();
  bool isLoading();
  String? getError();
  Future<void> loadRecurringDonations();
}

class RecurringDonationsOverviewRepositoryImpl
    with RecurringDonationsOverviewRepository {
  RecurringDonationsOverviewRepositoryImpl(
    this.apiService,
    this.collectGroupRepository,
  );

  final APIService apiService;
  final CollectGroupRepository collectGroupRepository;
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
  Future<void> loadRecurringDonations() async {
    _isLoading = true;
    _error = null;
    _donationsController.add(_donations);

    try {
      final response = await apiService.fetchRecurringDonations(
        params: {'userId': 'current'},
      );

      final result = <RecurringDonation>[];
      for (final item in response) {
        result.add(RecurringDonation.fromJson(item as Map<String, dynamic>));
      }

      // Fetch collect groups and merge them with recurring donations
      final collectGroups = await collectGroupRepository.getCollectGroupList();

      for (var i = 0; i < result.length; i++) {
        final recurringDonation = result[i];
        final collectGroup = collectGroups.firstWhere(
          (element) => element.nameSpace == recurringDonation.namespace,
          orElse: () {
            // Log if collect group not found
            debugPrint(
              'Collection with namespace ${recurringDonation.namespace} not found',
            );
            return const CollectGroup.empty();
          },
        );

        final recurringDonationWithCollectGroup = recurringDonation.copyWith(
          collectGroup: collectGroup,
        );
        result[i] = recurringDonationWithCollectGroup;
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
