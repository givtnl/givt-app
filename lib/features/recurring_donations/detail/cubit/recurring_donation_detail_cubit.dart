import 'dart:async';

import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/recurring_donations/detail/repositories/recurring_donation_detail_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'recurring_donation_detail_state.dart';

/// Cubit responsible for managing recurring donation detail state.
/// Uses [RecurringDonationDetailRepository] for fetching detail data.
class RecurringDonationDetailCubit extends CommonCubit<RecurringDonationDetailUIModel, RecurringDonationDetailCustom> {
  RecurringDonationDetailCubit(
    this._recurringDonationDetailRepository,
  ) : super(const BaseState.loading());

  final RecurringDonationDetailRepository _recurringDonationDetailRepository;
  StreamSubscription<RecurringDonationDetailUIModel>? _detailSubscription;

  @override
  void init() {
    _setupStreams();
    _loadRecurringDonationDetail();
  }

  void _setupStreams() {
    _detailSubscription = _recurringDonationDetailRepository.onDetailChanged().listen(
      _onDetailChanged,
      onError: (error) {
        LoggingInfo.instance.error(
          'Error in recurring donation detail stream: $error',
          methodName: 'RecurringDonationDetailCubit._setupStreams',
        );
      },
    );
  }

  void _onDetailChanged(RecurringDonationDetailUIModel detail) {
    emitData(detail);
  }

  Future<void> _loadRecurringDonationDetail() async {
    try {
      emitLoading();
      await _recurringDonationDetailRepository.loadRecurringDonationDetail();
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load recurring donation detail: $error',
        methodName: 'RecurringDonationDetailCubit._loadRecurringDonationDetail',
      );
    }
  }

  void onManageDonationPressed() {
    emitCustom(const RecurringDonationDetailCustom.manageDonation());
  }

  @override
  RecurringDonationDetailUIModel _createUIModel() {
    return _recurringDonationDetailRepository.getDetail();
  }

  @override
  Future<void> close() {
    _detailSubscription?.cancel();
    return super.close();
  }
}
