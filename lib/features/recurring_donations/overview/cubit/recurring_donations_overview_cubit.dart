import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/repositories/recurring_donations_overview_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

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
      emitData(_createUIModel());
    }
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

    return RecurringDonationsOverviewUIModel(
      currentDonations: donations
          .where((d) => d.currentState == RecurringDonationState.active)
          .toList(),
      pastDonations: donations
          .where((d) => d.currentState != RecurringDonationState.active)
          .toList(),
      isLoading: isLoading,
      error: error,
    );
  }
}
