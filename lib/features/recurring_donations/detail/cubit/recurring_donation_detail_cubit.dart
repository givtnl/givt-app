import 'dart:async';

import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/recurring_donations/detail/repositories/recurring_donation_detail_repository.dart';
import 'package:givt_app/features/recurring_donations/overview/repositories/recurring_donations_overview_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'recurring_donation_detail_state.dart';

/// Cubit responsible for managing recurring donation detail state.
/// Uses [RecurringDonationDetailRepository] for fetching detail data.
class RecurringDonationDetailCubit extends CommonCubit<RecurringDonationDetailUIModel, RecurringDonationDetailCustom> {
  RecurringDonationDetailCubit(
    this._recurringDonationDetailRepository,
    this._recurringDonationsOverviewRepository,
  ) : super(const BaseState.loading());

  final RecurringDonationDetailRepository _recurringDonationDetailRepository;
  final RecurringDonationsOverviewRepository _recurringDonationsOverviewRepository;

  bool _isPausing = false;

  void init() {
    _loadRecurringDonationDetail();
  }

  Future<void> _loadRecurringDonationDetail() async {
    try {
      emitLoading();
      await _recurringDonationDetailRepository.loadRecurringDonationDetail();
      
      // After loading, emit the data
      final uiModel = _createUIModel();
      emitData(uiModel);
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load recurring donation detail: $error',
        methodName: 'RecurringDonationDetailCubit._loadRecurringDonationDetail',
      );
      emitError(error.toString());
    }
  }

  void onManageDonationPressed() {
    emitCustom(const RecurringDonationDetailCustom.manageDonation());
    emitData(_createUIModel());
  }

  void onPauseDonationPressed() {
    emitCustom(const RecurringDonationDetailCustom.showPauseDonationSheet());
    emitData(_createUIModel());
  }

  void onPauseRestartDateSelected(DateTime restartDate) {
    emitCustom(
      RecurringDonationDetailCustom.showPauseDonationConfirmation(
        restartDate: restartDate,
      ),
    );
    emitData(_createUIModel());
  }

  Future<void> pauseDonation(DateTime restartDate) async {
    if (_isPausing) {
      return;
    }

    _isPausing = true;

    try {
      await _recurringDonationDetailRepository.pauseDonation(
        restartDate: restartDate,
      );
      if (isClosed) return;

      await Future.wait([
        _recurringDonationDetailRepository.loadRecurringDonationDetail(),
        _recurringDonationsOverviewRepository.loadRecurringDonations(
          status: 'active',
        ),
      ]);
      if (isClosed) return;

      _isPausing = false;
      emitData(_createUIModel());
      emitCustom(
        RecurringDonationDetailCustom.pauseDonationSucceeded(
          restartDate: restartDate,
        ),
      );
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to pause recurring donation: $error',
        methodName: 'RecurringDonationDetailCubit.pauseDonation',
      );
      if (isClosed) return;

      _isPausing = false;
      emitCustom(const RecurringDonationDetailCustom.pauseDonationFailed());
      emitData(_createUIModel());
    }
  }

  RecurringDonationDetailUIModel _createUIModel() {
    return RecurringDonationDetailUIModel(
      organizationName: _recurringDonationDetailRepository.getOrganizationName(),
      organizationIcon: 'assets/images/church_icon.png', // Legacy field, kept for compatibility
      organisationType: _recurringDonationDetailRepository.getOrganisationType(),
      totalDonated: _recurringDonationDetailRepository.getTotalDonated(),
      remainingTime: _recurringDonationDetailRepository.getRemainingTime(),
      endDate: _recurringDonationDetailRepository.getEndDate(),
      progress: _recurringDonationDetailRepository.getProgress(),
      history: _recurringDonationDetailRepository.getHistory(),
      isLoading: _recurringDonationDetailRepository.isLoading(),
      isActive: _recurringDonationDetailRepository.isRecurringDonationActive(),
      monthsHelped: _recurringDonationDetailRepository.getMonthsHelped(),
      error: _recurringDonationDetailRepository.getError(),
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
