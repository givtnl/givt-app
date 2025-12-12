import 'dart:async';

import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/features/review_donations/models/review_donations_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

/// Cubit responsible for managing review donations state.
/// Uses [DonationOverviewRepository] for fetching donation data.
class ReviewDonationsCubit
    extends CommonCubit<ReviewDonationsUIModel, dynamic> {
  ReviewDonationsCubit(
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
              methodName: 'ReviewDonationsCubit._setupStreams',
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
      emitError(_donationOverviewRepository.getError());
    } else {
      _emitData();
    }
  }

  Future<void> _loadDonations() async {
    try {
      await _donationOverviewRepository.loadDonations();
      _emitData();
    } on Exception catch (error) {
      LoggingInfo.instance.error(
        'Failed to load donations: $error',
        methodName: 'ReviewDonationsCubit._loadDonations',
      );

      // Check if cubit is closed before emitting states
      if (isClosed) return;

      // Emit error state
      emitError(error.toString());
    }
  }

  void _emitData() {
    // Check if cubit is closed before emitting states
    if (isClosed) return;

    final allDonations = _donationOverviewRepository.getDonations();
    final pendingDonations = _filterPendingDonations(allDonations);
    final uiModel = ReviewDonationsUIModel.fromDonations(pendingDonations);
    emitData(uiModel);
  }

  /// Filters donations to show only pending/created status
  List<DonationItem> _filterPendingDonations(List<DonationItem> donations) {
    return donations.where((donation) {
      final statusType = donation.status.type;
      return statusType == DonationStatusType.created ||
          statusType == DonationStatusType.inProcess;
    }).toList();
  }

  @override
  Future<void> close() {
    _donationsSubscription?.cancel();
    return super.close();
  }
}
