import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/repositories/recurring_donations_overview_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

part 'recurring_donations_overview_state.dart';

/// Cubit responsible for managing recurring donations overview state.
/// Uses [RecurringDonationsOverviewRepository] for fetching donation data.
class RecurringDonationsOverviewCubit
    extends
        CommonCubit<
          RecurringDonationsOverviewUIModel,
          RecurringDonationsOverviewCustom
        > {
  RecurringDonationsOverviewCubit(
    this._recurringDonationsOverviewRepository,
  ) : super(const BaseState.loading());

  final RecurringDonationsOverviewRepository _recurringDonationsOverviewRepository;

  void init() {
    _setupStreams();
    _loadRecurringDonations();
  }

  void _setupStreams() {
    _recurringDonationsOverviewRepository.onRecurringDonationsChanged().listen(
      _onRecurringDonationsChanged,
      onError: (error) {
        LoggingInfo.instance.error(
          'Error in recurring donations stream: $error',
          methodName: 'RecurringDonationsOverviewCubit._setupStreams',
        );
      },
    );
  }

  void _onRecurringDonationsChanged(List<RecurringDonation> donations) {
    if (_recurringDonationsOverviewRepository.isLoading()) {
      emitLoading();
    } else {
      // Track overall donation status for analytics
      _trackDonationsStatus(donations);
      emitData(_createUIModel());
    }
  }

  /// Tracks overall donation status for analytics purposes
  void _trackDonationsStatus(List<RecurringDonation> donations) {
    if (donations.isEmpty) return;
    
    final activeDonations = donations.where((d) => d.currentState == RecurringDonationState.active).length;
    final completedDonations = donations.where((d) => d.isCompleted).length;
    final unlimitedDonations = donations.where((d) => d.endsAfterTurns == 999).length;
    
    LoggingInfo.instance.info(
      'Recurring donations loaded: total: ${donations.length}, '
      'active: $activeDonations, completed: $completedDonations, '
      'unlimited: $unlimitedDonations',
      methodName: 'RecurringDonationsOverviewCubit._trackDonationsStatus',
    );
  }

  Future<void> _loadRecurringDonations() async {
    try {
      await _recurringDonationsOverviewRepository.loadRecurringDonations();
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load recurring donations: $error',
        methodName: 'RecurringDonationsOverviewCubit._loadRecurringDonations',
      );
    }
  }

  void onTabChanged(int index) {
    emitData(_createUIModel());
  }

  void onAddRecurringDonationPressed() {
    emitCustom(
      const RecurringDonationsOverviewCustom.navigateToAddRecurringDonation(),
    );
  }

  RecurringDonationsOverviewUIModel _createUIModel() {
    final donations = _recurringDonationsOverviewRepository.getRecurringDonations();
    final isLoading = _recurringDonationsOverviewRepository.isLoading();
    final error = _recurringDonationsOverviewRepository.getError();

    // Calculate progress information for each donation
    final currentDonationsWithProgress = donations
        .where((d) => d.currentState == RecurringDonationState.active)
        .map(_createDonationWithProgress)
        .toList();

    final pastDonationsWithProgress = donations
        .where((d) => d.currentState != RecurringDonationState.active)
        .map(_createDonationWithProgress)
        .toList();

    return RecurringDonationsOverviewUIModel(
      currentDonations: currentDonationsWithProgress,
      pastDonations: pastDonationsWithProgress,
      isLoading: isLoading,
      error: error,
    );
  }

  /// Creates a RecurringDonationWithProgress from a RecurringDonation
  RecurringDonationWithProgress _createDonationWithProgress(RecurringDonation donation) {
    final completedTurns = donation.getCompletedTurns();
    final remainingTurns = donation.getRemainingTurns();
    final progressPercentage = donation.getProgressPercentage();
    final isCompleted = donation.isCompleted;
    final nextDonationDate = donation.getNextDonationDateFromStart();

    // Track progress calculation for analytics
    _trackProgressCalculation(donation, completedTurns, remainingTurns, progressPercentage);

    return RecurringDonationWithProgress(
      donation: donation,
      completedTurns: completedTurns,
      remainingTurns: remainingTurns,
      progressPercentage: progressPercentage,
      isCompleted: isCompleted,
      nextDonationDate: nextDonationDate,
    );
  }

  /// Tracks progress calculation for analytics purposes
  void _trackProgressCalculation(
    RecurringDonation donation,
    int completedTurns,
    int remainingTurns,
    double progressPercentage,
  ) {
    // Only track if there's a meaningful progress calculation
    if (donation.endsAfterTurns > 0 && donation.endsAfterTurns != 999) {
      LoggingInfo.instance.info(
        'Progress calculated for donation ${donation.id}: '
        'completed: $completedTurns, remaining: $remainingTurns, '
        'progress: ${(progressPercentage * 100).toStringAsFixed(1)}%',
        methodName: 'RecurringDonationsOverviewCubit._trackProgressCalculation',
      );
    }
  }
}
