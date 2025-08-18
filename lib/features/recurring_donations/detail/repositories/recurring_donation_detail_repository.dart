import 'dart:async';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/recurring_donation_detail_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/repositories/recurring_donations_overview_repository.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

mixin RecurringDonationDetailRepository {
  Stream<RecurringDonationDetailUIModel> onDetailChanged();
  RecurringDonationDetailUIModel getDetail();
  bool isLoading();
  String? getError();
  Future<void> loadRecurringDonationDetail();
  void setRecurringDonation(RecurringDonation donation);
}

class RecurringDonationDetailRepositoryImpl with RecurringDonationDetailRepository {
  RecurringDonationDetailRepositoryImpl(
    this.apiService,
    this.collectGroupRepository,
  );

  final APIService apiService;
  final CollectGroupRepository collectGroupRepository;
  final StreamController<RecurringDonationDetailUIModel> _detailController = StreamController<RecurringDonationDetailUIModel>.broadcast();
  
  RecurringDonation? _recurringDonation;
  RecurringDonationDetailUIModel _detail = const RecurringDonationDetailUIModel(
    organizationName: '',
    organizationIcon: '',
    totalDonated: 0.0,
    remainingTime: '',
    endDate: null,
    progress: null,
    history: [],
    isLoading: false,
  );
  bool _isLoading = false;
  String? _error;

  @override
  Stream<RecurringDonationDetailUIModel> onDetailChanged() {
    return _detailController.stream;
  }

  void _emitDetail(RecurringDonationDetailUIModel detail) {
    if (!_detailController.isClosed) {
      _detailController.add(detail);
    }
  }

  @override
  RecurringDonationDetailUIModel getDetail() {
    return _detail;
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
  void setRecurringDonation(RecurringDonation donation) {
    _recurringDonation = donation;
  }

  @override
  Future<void> loadRecurringDonationDetail() async {
    if (_recurringDonation == null) {
      _error = 'No recurring donation set';
      _emitDetail(_detail);
      return;
    }

    _isLoading = true;
    _error = null;
          _detail = _detail.copyWith(isLoading: true);
      _emitDetail(_detail);

    try {
      // Fetch collect groups and merge them with the recurring donation
      final collectGroups = await collectGroupRepository.getCollectGroupList();
      final collectGroup = collectGroups.firstWhere(
        (element) => element.nameSpace == _recurringDonation!.namespace,
        orElse: () {
          print('Collection with namespace ${_recurringDonation!.namespace} not found');
          return const CollectGroup.empty();
        },
      );

      // Update the recurring donation with collect group information
      final recurringDonationWithCollectGroup = _recurringDonation!.copyWith(collectGroup: collectGroup);
      _recurringDonation = recurringDonationWithCollectGroup;

      // Fetch donation instances from API
      final instancesResponse = await apiService.fetchRecurringInstances(_recurringDonation!.id);
      
      // Parse the response and create history items (without status determination yet)
      final rawHistory = _parseRawHistoryFromResponse(instancesResponse as Map<String, dynamic>);
      
      // Now determine the correct status for each item based on recurring donation context
      final history = _determineHistoryStatuses(rawHistory);
      
      // Calculate basic details first (without progress, as we need _detail to be initialized)
      final totalDonated = _calculateTotalDonated(history);
      final remainingTime = _calculateRemainingTime();
      final endDate = _recurringDonation!.endsAfterTurns != 999 ? _recurringDonation!.endDate : null;
      
      // Create the detail model with the parsed history first
      _detail = RecurringDonationDetailUIModel(
        organizationName: _recurringDonation!.collectGroup.orgName,
        organizationIcon: 'assets/images/church_icon.png', // Default icon
        totalDonated: totalDonated,
        remainingTime: remainingTime,
        endDate: endDate,
        progress: null, // We'll calculate this after _detail is initialized
        history: history,
        isLoading: false,
        error: null,
      );
      
      // Now calculate progress (after _detail is initialized)
      final progress = _calculateProgress();
      
      // Only add upcoming donation if the recurring donation is still active
      List<DonationHistoryItem> finalHistory = history;
      if (_isRecurringDonationActive()) {
        final upcomingDonation = _createUpcomingDonation();
        finalHistory = [upcomingDonation, ...history];
      }
      
      // Update the detail with the complete history including progress
      _detail = _detail.copyWith(
        history: finalHistory,
        progress: progress,
      );
      
      _error = null;
    } catch (error) {
      _error = error.toString();
      _detail = _detail.copyWith(error: error.toString());
    } finally {
      _isLoading = false;
      _emitDetail(_detail);
    }
  }

  List<Map<String, dynamic>> _parseRawHistoryFromResponse(Map<String, dynamic> response) {
    final results = response['results'] as List<dynamic>? ?? [];
    final rawHistory = <Map<String, dynamic>>[];
    
    for (final item in results) {
      final itemMap = item as Map<String, dynamic>;
      rawHistory.add(itemMap);
    }
    
    return rawHistory;
  }

  List<DonationHistoryItem> _determineHistoryStatuses(List<Map<String, dynamic>> rawHistory) {
    final history = <DonationHistoryItem>[];
    
    for (final item in rawHistory) {
      final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
      final date = DateTime.tryParse(item['timestamp'] as String? ?? '') ?? DateTime.now();
      final status = _determineStatus(item);
      final icon = _getIconForStatus(status);
      
      history.add(DonationHistoryItem(
        amount: amount,
        date: date,
        status: status,
        icon: icon,
      ));
    }
    
    // Sort by date, most recent first
    history.sort((a, b) => b.date.compareTo(a.date));
    
    return history;
  }

  DonationStatus _determineStatus(Map<String, dynamic> item) {
    final timestamp = DateTime.tryParse(item['timestamp'] as String? ?? '');
    if (timestamp == null) return DonationStatus.pending;
    
    final now = DateTime.now();
    // Only show upcoming status if the recurring donation is still active
    if (timestamp.isAfter(now) && _isRecurringDonationActive()) {
      return DonationStatus.upcoming;
    } else {
      return DonationStatus.completed;
    }
  }

  String _getIconForStatus(DonationStatus status) {
    switch (status) {
      case DonationStatus.upcoming:
        return 'assets/images/upcoming_icon.png';
      case DonationStatus.completed:
        return 'assets/images/completed_icon.png';
      case DonationStatus.pending:
        return 'assets/images/pending_icon.png';
    }
  }

  DonationProgress? _calculateProgress() {
    if (_recurringDonation!.endsAfterTurns == 999) return null;
    
    final total = _recurringDonation!.endsAfterTurns;
    // Count only completed donations (excluding upcoming ones)
    final completed = _detail.history
        .where((h) => h.status == DonationStatus.completed)
        .length;
    
    return DonationProgress(
      completed: completed,
      total: total,
    );
  }

  double _calculateTotalDonated(List<DonationHistoryItem> history) {
    return history
        .where((h) => h.status == DonationStatus.completed)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  String _calculateRemainingTime() {
    if (_recurringDonation!.endsAfterTurns == 999) return 'Unlimited';
    
    final endDate = _recurringDonation!.endDate;
    if (endDate == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = endDate.difference(now);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''}';
    } else {
      final days = difference.inDays;
      return '$days day${days > 1 ? 's' : ''}';
    }
  }

  bool _isRecurringDonationActive() {
    // Check if the recurring donation is still active (not in the past)
    if (_recurringDonation == null) return false;
    
    // Check if the end date is in the future
    if (_recurringDonation!.endDate != null) {
      return _recurringDonation!.endDate!.isAfter(DateTime.now());
    }
    
    // If no end date, check the current state
    return _recurringDonation!.currentState == RecurringDonationState.active;
  }

  DonationHistoryItem _createUpcomingDonation() {
    // Calculate the next donation date
    DateTime nextDonationDate;
    
    // Get completed donations from the current history (excluding upcoming ones)
    final completedDonations = _detail.history
        .where((h) => h.status == DonationStatus.completed)
        .toList();
    
    if (completedDonations.isNotEmpty) {
      // If we have completed donations, calculate next date from the most recent one
      try {
        final lastDonation = completedDonations
            .reduce((a, b) => a.date.isAfter(b.date) ? a : b);
        nextDonationDate = _recurringDonation!.getNextDonationDate(lastDonation.date);
      } catch (e) {
        // Fallback to start date if there's an issue with the reduce operation
        print('Error calculating next date from completed donations: $e');
        nextDonationDate = _recurringDonation!.getNextDonationDate(
          DateTime.parse(_recurringDonation!.startDate),
        );
      }
    } else {
      // If no completed donations, calculate from start date
      nextDonationDate = _recurringDonation!.getNextDonationDate(
        DateTime.parse(_recurringDonation!.startDate),
      );
    }

    return DonationHistoryItem(
      amount: _recurringDonation!.amountPerTurn.toDouble(),
      date: nextDonationDate,
      status: DonationStatus.upcoming,
      icon: 'assets/images/upcoming_icon.png',
    );
  }

  void dispose() {
    _detailController.close();
  }
}
