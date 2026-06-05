import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_history_item.dart';
import 'package:givt_app/features/external_donations/detail/repositories/external_donation_detail_repository.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'external_donation_detail_state.dart';

class ExternalDonationDetailCubit
    extends CommonCubit<ExternalDonationDetailUIModel, ExternalDonationDetailCustom> {
  ExternalDonationDetailCubit(
    this._repository,
  ) : super(const BaseState.loading());

  final ExternalDonationDetailRepository _repository;

  Future<void> init(ExternalDonation donation) async {
    emitLoading();
    try {
      await _repository.loadDetail(donation);
      if (isClosed) return;

      if (_repository.getError() != null || _repository.getDonation() == null) {
        emitError(null);
        return;
      }

      emitData(_createUIModel());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load external donation detail: $error',
        methodName: 'ExternalDonationDetailCubit.init',
      );
      if (isClosed) return;
      emitError(null);
    }
  }

  void onStopRecordingPressed() {
    emitCustom(const ExternalDonationDetailCustom.showStopRecordingModal());
  }

  Future<void> confirmStopRecording() async {
    final donation = _repository.getDonation();
    if (donation == null) {
      return;
    }

    try {
      final stopped = await _repository.stopDonation(donation.id);
      if (isClosed) return;

      if (!stopped) {
        emitCustom(const ExternalDonationDetailCustom.stopRecordingFailed());
        emitData(_createUIModel());
        return;
      }

      emitCustom(const ExternalDonationDetailCustom.stopRecordingSucceeded());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to stop external donation: $error',
        methodName: 'ExternalDonationDetailCubit.confirmStopRecording',
      );
      if (isClosed) return;
      emitCustom(const ExternalDonationDetailCustom.stopRecordingFailed());
      emitData(_createUIModel());
    }
  }

  ExternalDonationDetailUIModel _createUIModel() {
    final donation = _repository.getDonation()!;
    return ExternalDonationDetailUIModel(
      donation: donation,
      totalDonated: _repository.getTotalDonated(),
      givingDuration: _repository.getGivingDuration(),
      history: _repository.getHistory(),
    );
  }
}
