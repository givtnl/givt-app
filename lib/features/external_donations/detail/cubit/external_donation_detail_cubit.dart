import 'package:flutter/foundation.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_history_item.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_manage_field.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_scope.dart';
import 'package:givt_app/features/external_donations/detail/repositories/external_donation_detail_repository.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'external_donation_detail_state.dart';

class ExternalDonationDetailCubit
    extends CommonCubit<ExternalDonationDetailUIModel, ExternalDonationDetailCustom> {
  ExternalDonationDetailCubit(
    this._repository,
  ) : super(const BaseState.loading());

  final ExternalDonationDetailRepository _repository;

  bool _isSelectionMode = false;
  Set<String> _selectedTransactionIds = {};
  bool _isSaving = false;

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

  void onManagePressed() {
    emitCustom(const ExternalDonationDetailCustom.showManageSheet());
  }

  void onManageFieldPressed(ExternalDonationManageField field) {
    final donation = _repository.getDonation();
    if (donation == null) {
      return;
    }

    if (donation.isOneOff) {
      switch (field) {
        case ExternalDonationManageField.amount:
          emitCustom(
            const ExternalDonationDetailCustom.showAmountEditor(isBulk: false),
          );
        case ExternalDonationManageField.date:
          emitCustom(const ExternalDonationDetailCustom.showDateEditor());
        case ExternalDonationManageField.frequency:
        case ExternalDonationManageField.startDate:
          return;
      }
      return;
    }

    switch (field) {
      case ExternalDonationManageField.amount:
      case ExternalDonationManageField.frequency:
        emitCustom(
          ExternalDonationDetailCustom.showScopeSheet(field: field),
        );
      case ExternalDonationManageField.startDate:
        emitCustom(const ExternalDonationDetailCustom.showStartDateEditor());
      case ExternalDonationManageField.date:
        return;
    }
  }

  void onScopeSelected({
    required ExternalDonationManageField field,
    required ExternalDonationUpdateScope scope,
  }) {
    switch (field) {
      case ExternalDonationManageField.amount:
        emitCustom(
          ExternalDonationDetailCustom.showAmountEditor(
            scope: scope,
            isBulk: false,
          ),
        );
      case ExternalDonationManageField.frequency:
        emitCustom(
          ExternalDonationDetailCustom.showFrequencyEditor(scope: scope),
        );
      case ExternalDonationManageField.startDate:
      case ExternalDonationManageField.date:
        return;
    }
  }

  void onDeleteDonationPressed() {
    emitCustom(const ExternalDonationDetailCustom.showDeleteDonationModal());
  }

  void onEditSpecificRecordsPressed() {
    _isSelectionMode = true;
    _selectedTransactionIds = {};
    emitData(_createUIModel());
  }

  void onCancelSelectionMode() {
    _isSelectionMode = false;
    _selectedTransactionIds = {};
    emitData(_createUIModel());
  }

  void onToggleHistoryItemSelection(ExternalDonationHistoryItem item) {
    if (!item.isSelectable || item.transactionId == null) {
      return;
    }

    final updated = Set<String>.from(_selectedTransactionIds);
    if (updated.contains(item.transactionId)) {
      updated.remove(item.transactionId);
    } else {
      updated.add(item.transactionId!);
    }
    _selectedTransactionIds = updated;
    emitData(_createUIModel());
  }

  void onToggleSelectAll() {
    final selectable = _createUIModel().selectableHistoryItems;
    if (selectable.isEmpty) {
      return;
    }

    final allSelected = selectable.every(
      (item) => _selectedTransactionIds.contains(item.transactionId),
    );

    if (allSelected) {
      _selectedTransactionIds = {};
    } else {
      _selectedTransactionIds = selectable
          .map((item) => item.transactionId!)
          .toSet();
    }
    emitData(_createUIModel());
  }

  void onBulkEditPressed() {
    if (_selectedTransactionIds.isEmpty) {
      return;
    }
    emitCustom(
      const ExternalDonationDetailCustom.showAmountEditor(isBulk: true),
    );
  }

  void onBulkDeletePressed() {
    if (_selectedTransactionIds.isEmpty) {
      return;
    }
    emitCustom(const ExternalDonationDetailCustom.showBulkDeleteModal());
  }

  Future<void> saveAmount({
    required double amount,
    ExternalDonationUpdateScope? scope,
    required bool isBulk,
  }) async {
    final donation = _repository.getDonation();
    if (donation == null) {
      return;
    }

    _isSaving = true;
    emitData(_createUIModel());

    try {
      final success = isBulk
          ? await _repository.bulkUpdateTransactions(
              transactionIds: _selectedTransactionIds.toList(),
              newAmount: amount,
            )
          : donation.isOneOff
              ? await _repository.updateOneOff(
                  externalDonationId: donation.id,
                  amount: amount,
                )
              : await _repository.updateAmount(
                  externalDonationId: donation.id,
                  amount: amount,
                  scope: scope,
                );

      if (isClosed) return;

      _isSaving = false;
      if (!success) {
        emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
        emitData(_createUIModel());
        return;
      }

      if (isBulk) {
        _isSelectionMode = false;
        _selectedTransactionIds = {};
      }

      emitCustom(const ExternalDonationDetailCustom.manageUpdateSucceeded());
      emitData(_createUIModel());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to update external donation amount: $error',
        methodName: 'ExternalDonationDetailCubit.saveAmount',
      );
      if (isClosed) return;
      _isSaving = false;
      emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
      emitData(_createUIModel());
    }
  }

  Future<void> saveFrequency({
    required ExternalDonationFrequency frequency,
    required DateTime anchorDate,
    required ExternalDonationUpdateScope scope,
  }) async {
    final donation = _repository.getDonation();
    if (donation == null) {
      return;
    }

    _isSaving = true;
    emitData(_createUIModel());

    try {
      final success = await _repository.updateFrequency(
        externalDonationId: donation.id,
        frequency: frequency,
        anchorDate: anchorDate,
        scope: scope,
      );

      if (isClosed) return;

      _isSaving = false;
      if (!success) {
        emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
        emitData(_createUIModel());
        return;
      }

      emitCustom(const ExternalDonationDetailCustom.manageUpdateSucceeded());
      emitData(_createUIModel());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to update external donation frequency: $error',
        methodName: 'ExternalDonationDetailCubit.saveFrequency',
      );
      if (isClosed) return;
      _isSaving = false;
      emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
      emitData(_createUIModel());
    }
  }

  Future<void> saveStartDate(DateTime startDate) async {
    final donation = _repository.getDonation();
    if (donation == null) {
      return;
    }

    _isSaving = true;
    emitData(_createUIModel());

    try {
      final success = await _repository.updateStartDate(
        externalDonationId: donation.id,
        startDate: startDate,
      );

      if (isClosed) return;

      _isSaving = false;
      if (!success) {
        emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
        emitData(_createUIModel());
        return;
      }

      emitCustom(const ExternalDonationDetailCustom.manageUpdateSucceeded());
      emitData(_createUIModel());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to update external donation start date: $error',
        methodName: 'ExternalDonationDetailCubit.saveStartDate',
      );
      if (isClosed) return;
      _isSaving = false;
      emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
      emitData(_createUIModel());
    }
  }

  Future<void> saveOneOffDate(DateTime date) async {
    final donation = _repository.getDonation();
    if (donation == null) {
      return;
    }

    _isSaving = true;
    emitData(_createUIModel());

    try {
      final success = await _repository.updateOneOff(
        externalDonationId: donation.id,
        date: date,
      );

      if (isClosed) return;

      _isSaving = false;
      if (!success) {
        emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
        emitData(_createUIModel());
        return;
      }

      emitCustom(const ExternalDonationDetailCustom.manageUpdateSucceeded());
      emitData(_createUIModel());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to update external donation date: $error',
        methodName: 'ExternalDonationDetailCubit.saveOneOffDate',
      );
      if (isClosed) return;
      _isSaving = false;
      emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
      emitData(_createUIModel());
    }
  }

  Future<void> confirmDeleteDonation() async {
    final donation = _repository.getDonation();
    if (donation == null) {
      return;
    }

    _isSaving = true;
    emitData(_createUIModel());

    try {
      final success = await _repository.deleteDonation(donation.id);
      if (isClosed) return;

      _isSaving = false;
      if (!success) {
        emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
        emitData(_createUIModel());
        return;
      }

      emitCustom(const ExternalDonationDetailCustom.donationDeleted());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to delete external donation: $error',
        methodName: 'ExternalDonationDetailCubit.confirmDeleteDonation',
      );
      if (isClosed) return;
      _isSaving = false;
      emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
      emitData(_createUIModel());
    }
  }

  Future<void> confirmBulkDelete() async {
    if (_selectedTransactionIds.isEmpty) {
      return;
    }

    _isSaving = true;
    emitData(_createUIModel());

    try {
      final success = await _repository.bulkDeleteTransactions(
        transactionIds: _selectedTransactionIds.toList(),
      );
      if (isClosed) return;

      _isSaving = false;
      if (!success) {
        emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
        emitData(_createUIModel());
        return;
      }

      _isSelectionMode = false;
      _selectedTransactionIds = {};
      emitCustom(const ExternalDonationDetailCustom.manageUpdateSucceeded());
      emitData(_createUIModel());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to bulk delete external donation transactions: $error',
        methodName: 'ExternalDonationDetailCubit.confirmBulkDelete',
      );
      if (isClosed) return;
      _isSaving = false;
      emitCustom(const ExternalDonationDetailCustom.manageUpdateFailed());
      emitData(_createUIModel());
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
      isSelectionMode: _isSelectionMode,
      selectedTransactionIds: _selectedTransactionIds,
      isSaving: _isSaving,
    );
  }
}
