import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_ui_model.dart';
import 'package:givt_app/features/external_donations/create/repositories/external_donation_create_repository.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/collect_group.dart';

part 'external_donation_create_state.dart';

class ExternalDonationCreateCubit
    extends CommonCubit<ExternalDonationCreateUIModel, ExternalDonationCreateCustom> {
  ExternalDonationCreateCubit(this._repository)
      : super(const BaseState.loading());

  final ExternalDonationCreateRepository _repository;

  Future<void> init() async {
    emitLoading();
    try {
      _repository.resetDraft();
      await _repository.ensureOrganisationsLoaded();
      if (isClosed) return;
      _emitData();
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to init external donation create flow: $error',
        methodName: 'ExternalDonationCreateCubit.init',
      );
      if (isClosed) return;
      emitError(error.toString());
    }
  }

  void selectKnownOrganisation(CollectGroup organisation) {
    _repository.selectKnownOrganisation(organisation);
    _emitData();
  }

  void selectCustomOrganisation(String name) {
    _repository.selectCustomOrganisation(name);
    _emitData();
  }

  void updateTaxDeductible(bool value) {
    _repository.updateTaxDeductible(value);
    _emitData();
  }

  void updateAmount(String amount) {
    _repository.updateAmount(amount);
    _emitData();
  }

  void selectOneOff() {
    _repository.selectOneOff();
    _emitData();
  }

  void selectRecurring(ExternalDonationFrequency frequency) {
    _repository.selectRecurring(frequency);
    _emitData();
  }

  void updateDateMade(DateTime date) {
    _repository.updateDateMade(date);
    _emitData();
  }

  void updateLastGiftDate(DateTime date) {
    _repository.updateLastGiftDate(date);
    _emitData();
  }

  void updateStartMonthYear(DateTime monthYear) {
    _repository.updateStartMonthYear(monthYear);
    _emitData();
  }

  void continueFromOrganisation() {
    if (!_repository.getDraft().hasOrganisation) {
      return;
    }
    _emitNavigate(const ExternalDonationCreateCustom.navigateToDonationType());
  }

  void continueFromDonationType() {
    if (!_repository.getDraft().isDonationTypeStepValid) {
      return;
    }
    final draft = _repository.getDraft();
    if (draft.isOneOff == true) {
      _emitNavigate(const ExternalDonationCreateCustom.navigateToOneOffDate());
      return;
    }
    _emitNavigate(const ExternalDonationCreateCustom.navigateToLastGiftDate());
  }

  void continueFromLastGiftDate() {
    if (!_repository.getDraft().isLastGiftDateValid) {
      return;
    }
    _emitNavigate(const ExternalDonationCreateCustom.navigateToStartMonthYear());
  }

  void continueFromStartMonthYear() {
    if (!_repository.getDraft().isStartMonthYearValid) {
      return;
    }
    submit();
  }

  Future<void> submitOneOff() async {
    if (!_repository.getDraft().isOneOffDateValid) {
      return;
    }
    await submit();
  }

  Future<void> submit() async {
    _emitData(isSubmitting: true);
    try {
      final created = await _repository.submit();
      if (isClosed) return;
      if (created == null) {
        emitError('Failed to create external donation');
        _emitData(isSubmitting: false);
        return;
      }
      _emitData(isSubmitting: false);
      _emitNavigate(const ExternalDonationCreateCustom.navigateToSuccess());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to submit external donation: $error',
        methodName: 'ExternalDonationCreateCubit.submit',
      );
      if (isClosed) return;
      emitError(error.toString());
      _emitData(isSubmitting: false);
    }
  }

  void _emitData({bool isSubmitting = false}) {
    emitData(
      ExternalDonationCreateUIModel(
        draft: _repository.getDraft(),
        isSubmitting: isSubmitting,
      ),
    );
  }

  /// Emits a one-off navigation event, then restores [DataState] so the next
  /// step can render (BaseStateConsumer only builds UI from data/loading/error).
  void _emitNavigate(ExternalDonationCreateCustom action) {
    emitCustom(action);
    _emitData();
  }

  void clearDraftAfterSuccess() {
    _repository.resetDraft();
  }
}
