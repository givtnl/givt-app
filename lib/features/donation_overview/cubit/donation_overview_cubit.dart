import 'dart:async';

import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/donation_overview/models/donation_overview_custom.dart';
import 'package:givt_app/features/donation_overview/models/donation_overview_uimodel.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

/// Cubit responsible for managing donation overview state.
/// Uses [DonationOverviewRepository] for fetching donation data.
class DonationOverviewCubit
    extends CommonCubit<DonationOverviewUIModel, DonationOverviewCustom> {
  DonationOverviewCubit(
    this._donationOverviewRepository,
  ) : super(const BaseState.loading());

  final DonationOverviewRepository _donationOverviewRepository;
  StreamSubscription<List<dynamic>>? _donationsSubscription;

  Future<void> init() async {
    // First load donations to get initial data
    await _loadDonations();

    // Then set up streams to listen for changes
    _setupStreams();
  }

  void _setupStreams() {
    _donationsSubscription = _donationOverviewRepository
        .onDonationsChanged()
        .listen(
          _onDonationsChanged,
          onError: (Object error, StackTrace stackTrace) {
            LoggingInfo.instance.error(
              'Error in donations stream: $error',
              methodName: 'DonationOverviewCubit._setupStreams',
            );
          },
        );
  }

  void _onDonationsChanged(List<dynamic> donations) {
    // Check if cubit is closed before emitting states
    if (isClosed) return;

    if (_donationOverviewRepository.isLoading()) {
      emitLoading();
    } else if (_donationOverviewRepository.getError() != null) {
      // Handle error state
      // emitError(_donationOverviewRepository.getError());
    } else {
      _emitData();
    }
  }

  Future<void> _loadDonations() async {
    try {
      await _donationOverviewRepository.loadDonations();
      _emitData();
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load donations: $error',
        methodName: 'DonationOverviewCubit._loadDonations',
      );

      // Check if cubit is closed before emitting states
      if (isClosed) return;

      // Emit error state
      emitError(error.toString());
    }
  }

  Future<void> loadDonations() async {
    await _loadDonations();
  }

  void _emitData() {
    // Check if cubit is closed before emitting states
    if (isClosed) return;

    final donations = _donationOverviewRepository.getDonations();
    final uiModel = DonationOverviewUIModel.fromDonations(donations);
    emitData(uiModel);
  }

  Future<void> deleteDonation(List<int> ids) async {
    try {
      await _donationOverviewRepository.deleteDonation(ids);
      await _loadDonations();

      // Check if cubit is closed before emitting states
      if (isClosed) return;

      emitCustom(
        const DonationOverviewCustom.showSuccessMessage(
          'Donation(s) deleted successfully',
        ),
      );
    } catch (e) {
      // Check if cubit is closed before emitting states
      if (isClosed) return;

      emitCustom(
        DonationOverviewCustom.showErrorMessage(
          e.toString(),
        ),
      );
    }
  }

  Future<void> downloadYearlyOverview({required String year}) async {
    try {
      final fromDate = DateTime.parse('$year-01-01').toIso8601String();
      final tillDate = DateTime.parse(
        '${int.parse(year) + 1}-01-01',
      ).toIso8601String();

      final success = await _donationOverviewRepository.downloadYearlyOverview(
        fromDate: fromDate,
        toDate: tillDate,
      );

      // Check if cubit is closed before emitting states
      if (isClosed) return;

      if (success) {
        emitCustom(
          const DonationOverviewCustom.showSuccessMessage(
            'Yearly overview sent to your email',
          ),
        );
      } else {
        emitCustom(
          const DonationOverviewCustom.showErrorMessage(
            'Failed to download yearly overview',
          ),
        );
      }
    } catch (e) {
      // Check if cubit is closed before emitting states
      if (isClosed) return;

      emitCustom(
        DonationOverviewCustom.showErrorMessage(
          e.toString(),
        ),
      );
    }
  }

  void refreshDonations() {
    _loadDonations();
  }

  @override
  Future<void> close() {
    _donationsSubscription?.cancel();
    return super.close();
  }
}
