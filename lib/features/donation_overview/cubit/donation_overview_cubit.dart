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

  void init() {
    _setupStreams();
    _loadDonations();
  }

  void _setupStreams() {
    _donationOverviewRepository.onDonationsChanged().listen(
      _onDonationsChanged,
      onError: (error) {
        LoggingInfo.instance.error(
          'Error in donations stream: $error',
          methodName: 'DonationOverviewCubit._setupStreams',
        );
      },
    );
  }

  void _onDonationsChanged(List<dynamic> donations) {
    if (_donationOverviewRepository.isLoading()) {
      emitLoading();
    } else {
      _emitData();
    }
  }

  Future<void> _loadDonations() async {
    try {
      await _donationOverviewRepository.loadDonations();
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load donations: $error',
        methodName: 'DonationOverviewCubit._loadDonations',
      );
    }
  }

  Future<void> loadDonations() async {
    await _loadDonations();
  }

  void _emitData() {
    final donations = _donationOverviewRepository.getDonations();
    final uiModel = DonationOverviewUIModel.fromDonations(donations);
    emitData(uiModel);
  }

  Future<void> deleteDonation(List<int> ids) async {
    try {
      await _donationOverviewRepository.deleteDonation(ids);
      await _loadDonations();
      emitCustom(
        const DonationOverviewCustom.showSuccessMessage(
          'Donation(s) deleted successfully',
        ),
      );
    } catch (e) {
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
        body: {'fromDate': fromDate, 'tillDate': tillDate},
      );

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
