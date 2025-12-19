import 'dart:async';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/recurring_donation_detail_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

/// Repository for managing the details of a specific recurring donation.
mixin RecurringDonationDetailRepository {
  /// Returns whether the repository is currently loading data.
  bool isLoading();

  /// Returns the last error message, if any.
  String? getError();

  /// Loads the details and history for the current recurring donation.
  Future<void> loadRecurringDonationDetail();

  /// Sets the recurring donation to fetch details for.
  void setRecurringDonation(RecurringDonation donation);

  // Methods to get raw data for the cubit

  /// Returns the name of the organization for the recurring donation.
  String getOrganizationName();

  /// Returns the total amount donated so far.
  double getTotalDonated();

  /// Returns a human-readable string for the remaining time.
  String getRemainingTime();

  /// Returns the end date of the recurring donation, if applicable.
  DateTime? getEndDate();

  /// Returns the history of donations for this recurring donation.
  List<DonationHistoryItem> getHistory();

  /// Returns the number of months the user has helped this organization.
  int getMonthsHelped();

  /// Returns the progress of the recurring donation (completed vs total turns).
  DonationProgress? getProgress();

  /// Returns whether the recurring donation is currently active.
  bool isRecurringDonationActive();
}

/// Implementation of [RecurringDonationDetailRepository] that uses [APIService].
class RecurringDonationDetailRepositoryImpl
    with RecurringDonationDetailRepository {
  RecurringDonationDetailRepositoryImpl(
    this.apiService,
    this.collectGroupRepository,
  );

  final APIService apiService;
  final CollectGroupRepository collectGroupRepository;

  RecurringDonation? _recurringDonation;
  List<DonationHistoryItem> _history = [];
  bool _isLoading = false;
  String? _error;

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
      return;
    }

    _isLoading = true;
    _error = null;

    try {
      // Fetch donation instances from API
      final instancesResponse = await apiService.fetchRecurringDonationById(
        _recurringDonation!.id,
      );

      // Extract transactions from the API response
      final rawHistory = _extractTransactionsFromResponse(
        instancesResponse,
      );

      // Map the raw transaction data to history items
      final history = _mapToDonationHistoryItems(rawHistory);

      // Only add upcoming donation if the recurring donation is still active
      var finalHistory = history;
      if (isRecurringDonationActive()) {
        final upcomingDonation = _createUpcomingDonation();
        finalHistory = [upcomingDonation, ...history];
      }

      // Store the history
      _history = finalHistory;
      _error = null;
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
    }
  }

  /// Extracts the list of transactions from the API response.
  List<Map<String, dynamic>> _extractTransactionsFromResponse(
    Map<String, dynamic> response,
  ) {
    // The API returns transactions directly in the item object
    final item = response['item'] as Map<String, dynamic>?;
    if (item == null) return [];

    final transactions = item['transactions'] as List<dynamic>? ?? [];
    final rawHistory = <Map<String, dynamic>>[];

    for (final transaction in transactions) {
      final transactionMap = transaction as Map<String, dynamic>;
      rawHistory.add(transactionMap);
    }

    return rawHistory;
  }

  /// Maps raw transaction data from the API to [DonationHistoryItem] objects.
  /// This includes parsing the amount, status, icon, and confirmation date.
  List<DonationHistoryItem> _mapToDonationHistoryItems(
    List<Map<String, dynamic>> rawHistory,
  ) {
    final history = <DonationHistoryItem>[];

    for (final item in rawHistory) {
      final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
      final statusString = item['status'] as String? ?? 'Pending';
      final status = _mapStatusToEnum(statusString);
      final icon = _getStatusIcon(status);

      // Use the confirmed_date from the transaction, falling back to now if missing
      final dateString = item['confirmedDate'] as String?;
      final date = dateString != null
          ? DateTime.parse(dateString).toLocal()
          : DateTime.now();

      history.add(
        DonationHistoryItem(
          amount: amount,
          date: date,
          status: status,
          icon: icon,
        ),
      );
    }

    // Sort by date, most recent first
    history.sort((a, b) => b.date.compareTo(a.date));

    return history;
  }

  /// Maps a status string from the API to the [DonationStatus] enum.
  DonationStatus _mapStatusToEnum(String statusString) {
    switch (statusString.toLowerCase()) {
      case 'processed':
        return DonationStatus.processed;
      default:
        return DonationStatus.inprocess;
    }
  }

  /// Returns the asset path for the icon corresponding to a [DonationStatus].
  String _getStatusIcon(DonationStatus status) {
    switch (status) {
      case DonationStatus.upcoming:
        return 'assets/images/upcoming_icon.png';
      case DonationStatus.processed:
        return 'assets/images/completed_icon.png';
      case DonationStatus.inprocess:
        return 'assets/images/pending_icon.png';
    }
  }

  /// Calculates the number of months helped based on actual completed donations.
  int _calculateMonthsHelped(List<DonationHistoryItem> history) {
    final completedDonations = history
        .where((h) => h.status == DonationStatus.processed)
        .toList();

    if (completedDonations.isEmpty) return 0;

    // Sort by date to get the first and last completed donations
    completedDonations.sort((a, b) => a.date.compareTo(b.date));

    final firstDonation = completedDonations.first;
    final lastDonation = completedDonations.last;

    // Calculate months between first and last completed donation
    final difference = lastDonation.date.difference(firstDonation.date);
    final months = (difference.inDays / 30.44)
        .floor(); // Average days per month

    // Add 1 to include the month of the first donation
    return months + 1;
  }

  /// Calculates the total amount donated across all processed donations.
  double _calculateTotalDonated(List<DonationHistoryItem> history) {
    return history
        .where((h) => h.status == DonationStatus.processed)
        .fold(0, (sum, item) => sum + item.amount);
  }

  /// Calculates a human-readable string representing the remaining time
  /// until the recurring donation ends.
  String _calculateRemainingTime() {
    if (_recurringDonation!.numberOfTurns == 999) return 'Unlimited';

    final endDate = _recurringDonation!.calculatedEndDate;
    if (endDate == null) return 'Unlimited';

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

  /// Determines if the recurring donation is currently active based on its
  /// state and end date.
  bool isRecurringDonationActive() {
    if (_recurringDonation == null) return false;

    // Check if the donation is cancelled or finished
    if (_recurringDonation!.currentState == RecurringDonationState.cancelled ||
        _recurringDonation!.currentState == RecurringDonationState.finished) {
      return false;
    }

    // For active donations, also check if the end date is in the future
    final endDate = _recurringDonation!.calculatedEndDate;
    if (endDate != null) {
      return endDate.isAfter(DateTime.now());
    }

    // If no end date and state is active, assume it's active
    return _recurringDonation!.currentState == RecurringDonationState.active;
  }

  /// Creates a [DonationHistoryItem] for the next upcoming donation.
  DonationHistoryItem _createUpcomingDonation() {
    // Use API-provided next donation date if available, otherwise fall back to calculation
    DateTime nextDonationDate;

    final apiNextDate = _recurringDonation!.nextDonationDate;
    if (apiNextDate != null) {
      nextDonationDate = apiNextDate;
    } else {
      // Fallback to calculation if API data is not available
      final completedDonations = _history
          .where((h) => h.status == DonationStatus.processed)
          .toList();

      if (completedDonations.isNotEmpty) {
        // If we have completed donations, calculate next date from the most recent one
        try {
          final lastDonation = completedDonations.reduce(
            (a, b) => a.date.isAfter(b.date) ? a : b,
          );
          nextDonationDate = _recurringDonation!.getNextDonationDate(
            lastDonation.date,
          );
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
    }

    return DonationHistoryItem(
      amount: _recurringDonation!.amount,
      date: nextDonationDate,
      status: DonationStatus.upcoming,
      icon: 'assets/images/upcoming_icon.png',
    );
  }

  @override
  String getOrganizationName() {
    return _recurringDonation?.collectGroupName ?? '';
  }

  @override
  double getTotalDonated() {
    return _calculateTotalDonated(_history);
  }

  @override
  String getRemainingTime() {
    return _calculateRemainingTime();
  }

  @override
  DateTime? getEndDate() {
    if (_recurringDonation == null) return null;
    return _recurringDonation!.numberOfTurns != 999
        ? _recurringDonation!.calculatedEndDate
        : null;
  }

  @override
  List<DonationHistoryItem> getHistory() {
    return _history;
  }

  @override
  int getMonthsHelped() {
    return _calculateMonthsHelped(_history);
  }

  @override
  DonationProgress? getProgress() {
    if (_recurringDonation == null ||
        _recurringDonation!.numberOfTurns == 999) {
      return null;
    }

    final total = _recurringDonation!.numberOfTurns;
    // Use API-provided current turn instead of counting history items
    final completed = _recurringDonation!.currentTurn;

    return DonationProgress(
      completed: completed,
      total: total,
    );
  }

  /// Disposes of any resources used by the repository.
  void dispose() {
    // No-op as there's no StreamController to close
  }
}