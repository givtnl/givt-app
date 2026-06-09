part of 'external_donation_detail_cubit.dart';

class ExternalDonationDetailUIModel {
  const ExternalDonationDetailUIModel({
    required this.donation,
    required this.totalDonated,
    required this.givingDuration,
    required this.history,
    this.isSelectionMode = false,
    this.selectedTransactionIds = const {},
    this.isSaving = false,
  });

  final ExternalDonation donation;
  final double totalDonated;
  final GivingDuration? givingDuration;
  final List<ExternalDonationHistoryItem> history;
  final bool isSelectionMode;
  final Set<String> selectedTransactionIds;
  final bool isSaving;

  bool get isRecurring => donation.isRecurring;

  bool get isActive => donation.active;

  bool get hasSelection => selectedTransactionIds.isNotEmpty;

  int get selectedCount => selectedTransactionIds.length;

  List<ExternalDonationHistoryItem> get selectableHistoryItems =>
      history.where((item) => item.isSelectable).toList();

  bool get areAllSelectableItemsSelected {
    final selectable = selectableHistoryItems;
    if (selectable.isEmpty) {
      return false;
    }
    return selectable.every(
      (item) => selectedTransactionIds.contains(item.transactionId),
    );
  }

  ExternalDonationDetailUIModel copyWith({
    ExternalDonation? donation,
    double? totalDonated,
    GivingDuration? givingDuration,
    List<ExternalDonationHistoryItem>? history,
    bool? isSelectionMode,
    Set<String>? selectedTransactionIds,
    bool? isSaving,
  }) {
    return ExternalDonationDetailUIModel(
      donation: donation ?? this.donation,
      totalDonated: totalDonated ?? this.totalDonated,
      givingDuration: givingDuration ?? this.givingDuration,
      history: history ?? this.history,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedTransactionIds:
          selectedTransactionIds ?? this.selectedTransactionIds,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExternalDonationDetailUIModel &&
        other.donation == donation &&
        other.totalDonated == totalDonated &&
        other.givingDuration == givingDuration &&
        other.history == history &&
        other.isSelectionMode == isSelectionMode &&
        setEquals(other.selectedTransactionIds, selectedTransactionIds) &&
        other.isSaving == isSaving;
  }

  @override
  int get hashCode => Object.hash(
        donation,
        totalDonated,
        givingDuration,
        history,
        isSelectionMode,
        Object.hashAll(selectedTransactionIds),
        isSaving,
      );
}

sealed class ExternalDonationDetailCustom {
  const ExternalDonationDetailCustom();

  const factory ExternalDonationDetailCustom.showStopRecordingModal() =
      ShowStopRecordingModal;

  const factory ExternalDonationDetailCustom.stopRecordingSucceeded() =
      StopRecordingSucceeded;

  const factory ExternalDonationDetailCustom.stopRecordingFailed() =
      StopRecordingFailed;

  const factory ExternalDonationDetailCustom.showManageSheet() =
      ShowManageSheet;

  const factory ExternalDonationDetailCustom.showScopeSheet({
    required ExternalDonationManageField field,
  }) = ShowScopeSheet;

  const factory ExternalDonationDetailCustom.showAmountEditor({
    ExternalDonationUpdateScope? scope,
    required bool isBulk,
  }) = ShowAmountEditor;

  const factory ExternalDonationDetailCustom.showFrequencyEditor({
    required ExternalDonationUpdateScope scope,
  }) = ShowFrequencyEditor;

  const factory ExternalDonationDetailCustom.showStartDateEditor() =
      ShowStartDateEditor;

  const factory ExternalDonationDetailCustom.showDateEditor() = ShowDateEditor;

  const factory ExternalDonationDetailCustom.showDeleteDonationModal() =
      ShowDeleteDonationModal;

  const factory ExternalDonationDetailCustom.showBulkDeleteModal() =
      ShowBulkDeleteModal;

  const factory ExternalDonationDetailCustom.manageUpdateSucceeded() =
      ManageUpdateSucceeded;

  const factory ExternalDonationDetailCustom.manageUpdateFailed() =
      ManageUpdateFailed;

  const factory ExternalDonationDetailCustom.donationDeleted() =
      DonationDeleted;
}

class ShowStopRecordingModal extends ExternalDonationDetailCustom {
  const ShowStopRecordingModal();
}

class StopRecordingSucceeded extends ExternalDonationDetailCustom {
  const StopRecordingSucceeded();
}

class StopRecordingFailed extends ExternalDonationDetailCustom {
  const StopRecordingFailed();
}

class ShowManageSheet extends ExternalDonationDetailCustom {
  const ShowManageSheet();
}

class ShowScopeSheet extends ExternalDonationDetailCustom {
  const ShowScopeSheet({required this.field});

  final ExternalDonationManageField field;
}

class ShowAmountEditor extends ExternalDonationDetailCustom {
  const ShowAmountEditor({
    this.scope,
    required this.isBulk,
  });

  final ExternalDonationUpdateScope? scope;
  final bool isBulk;
}

class ShowFrequencyEditor extends ExternalDonationDetailCustom {
  const ShowFrequencyEditor({required this.scope});

  final ExternalDonationUpdateScope scope;
}

class ShowStartDateEditor extends ExternalDonationDetailCustom {
  const ShowStartDateEditor();
}

class ShowDateEditor extends ExternalDonationDetailCustom {
  const ShowDateEditor();
}

class ShowDeleteDonationModal extends ExternalDonationDetailCustom {
  const ShowDeleteDonationModal();
}

class ShowBulkDeleteModal extends ExternalDonationDetailCustom {
  const ShowBulkDeleteModal();
}

class ManageUpdateSucceeded extends ExternalDonationDetailCustom {
  const ManageUpdateSucceeded();
}

class ManageUpdateFailed extends ExternalDonationDetailCustom {
  const ManageUpdateFailed();
}

class DonationDeleted extends ExternalDonationDetailCustom {
  const DonationDeleted();
}
