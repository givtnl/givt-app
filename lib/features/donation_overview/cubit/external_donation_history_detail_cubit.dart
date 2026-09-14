import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_payload.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

sealed class ExternalDonationHistoryDetailCustom {
  const ExternalDonationHistoryDetailCustom();

  const factory ExternalDonationHistoryDetailCustom.mutationSucceeded() =
      ExternalDonationHistoryMutationSucceeded;

  const factory ExternalDonationHistoryDetailCustom.mutationFailed(
    String message,
  ) = ExternalDonationHistoryMutationFailed;

  const factory ExternalDonationHistoryDetailCustom.deleted() =
      ExternalDonationHistoryDeleted;
}

final class ExternalDonationHistoryMutationSucceeded
    extends ExternalDonationHistoryDetailCustom {
  const ExternalDonationHistoryMutationSucceeded();
}

final class ExternalDonationHistoryMutationFailed
    extends ExternalDonationHistoryDetailCustom {
  const ExternalDonationHistoryMutationFailed(this.message);

  final String message;
}

final class ExternalDonationHistoryDeleted
    extends ExternalDonationHistoryDetailCustom {
  const ExternalDonationHistoryDeleted();
}

class ExternalDonationHistoryDetailUIModel {
  const ExternalDonationHistoryDetailUIModel({
    required this.donation,
    this.isSaving = false,
  });

  final DonationItem donation;
  final bool isSaving;

  bool get isOneOff => !donation.isExternalRecurring;

  ExternalDonationHistoryDetailUIModel copyWith({
    DonationItem? donation,
    bool? isSaving,
  }) {
    return ExternalDonationHistoryDetailUIModel(
      donation: donation ?? this.donation,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class ExternalDonationHistoryDetailCubit extends CommonCubit<
    ExternalDonationHistoryDetailUIModel, ExternalDonationHistoryDetailCustom> {
  ExternalDonationHistoryDetailCubit(this._givtRepository)
      : super(const BaseState.loading());

  final GivtRepository _givtRepository;
  DonationItem? _donation;

  void init(DonationItem donation) {
    _donation = donation;
    emitData(ExternalDonationHistoryDetailUIModel(donation: donation));
  }

  /// Loads the series for [ExternalDonationDetailPage] (Manage).
  ///
  /// Uses the list endpoint so `active` is correct. `GET …/details` omits
  /// `Active` in the BFF mapping (serializes as false), which hides
  /// "I've stopped giving" for an otherwise active recurring donation.
  Future<ExternalDonation?> loadExternalDonationForManage() async {
    final donationId = _donation?.externalDonationId;
    if (donationId == null) {
      return null;
    }

    try {
      final donations = await _givtRepository.fetchExternalDonations();
      for (final donation in donations) {
        if (donation.id == donationId) {
          return donation;
        }
      }
      return null;
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load external donation for manage: $error',
        methodName:
            'ExternalDonationHistoryDetailCubit.loadExternalDonationForManage',
      );
      return null;
    }
  }

  Future<void> updateOneOffAmount(double amount) async {
    final donation = _donation;
    final externalDonationId = donation?.externalDonationId;
    if (donation == null || externalDonationId == null) {
      return;
    }

    await _runMutation(
      () => _givtRepository.updateExternalDonation(
        id: externalDonationId,
        body: ExternalDonationUpdatePayload.oneOffDate(
          amount: amount,
          date: donation.timeStamp ?? DateTime.now(),
        ),
      ),
      applyMutation: (current) => current.copyWith(amount: amount),
    );
  }

  Future<void> updateOneOffDate(DateTime date) async {
    final donation = _donation;
    final externalDonationId = donation?.externalDonationId;
    if (donation == null || externalDonationId == null) {
      return;
    }

    await _runMutation(
      () => _givtRepository.updateExternalDonation(
        id: externalDonationId,
        body: ExternalDonationUpdatePayload.oneOffDate(
          amount: donation.amount,
          date: date,
        ),
      ),
      applyMutation: (current) => current.copyWith(timeStamp: date),
    );
  }

  Future<void> deleteOneOff() async {
    final externalDonationId = _donation?.externalDonationId;
    if (externalDonationId == null) {
      return;
    }

    await _setSaving(true);
    try {
      final success =
          await _givtRepository.deleteExternalDonation(externalDonationId);
      if (success) {
        emitCustom(const ExternalDonationHistoryDetailCustom.deleted());
      } else {
        emitCustom(
          const ExternalDonationHistoryDetailCustom.mutationFailed(
            'delete_failed',
          ),
        );
      }
    } catch (error) {
      emitCustom(
        ExternalDonationHistoryDetailCustom.mutationFailed(error.toString()),
      );
    } finally {
      await _setSaving(false);
    }
  }

  Future<void> updateOccurrenceAmount(double amount) async {
    final transactionId = _donation?.externalTransactionId;
    if (transactionId == null) {
      return;
    }

    await _runMutation(
      () => _givtRepository.bulkUpdateExternalDonationTransactions(
        transactionIds: [transactionId],
        newAmount: amount,
      ),
      applyMutation: (current) => current.copyWith(amount: amount),
    );
  }

  Future<void> deleteOccurrence() async {
    final transactionId = _donation?.externalTransactionId;
    if (transactionId == null) {
      return;
    }

    await _setSaving(true);
    try {
      final success =
          await _givtRepository.bulkDeleteExternalDonationTransactions(
        transactionIds: [transactionId],
      );
      if (success) {
        emitCustom(const ExternalDonationHistoryDetailCustom.deleted());
      } else {
        emitCustom(
          const ExternalDonationHistoryDetailCustom.mutationFailed(
            'delete_failed',
          ),
        );
      }
    } catch (error) {
      emitCustom(
        ExternalDonationHistoryDetailCustom.mutationFailed(error.toString()),
      );
    } finally {
      await _setSaving(false);
    }
  }

  Future<void> _runMutation(
    Future<bool> Function() action, {
    DonationItem Function(DonationItem donation)? applyMutation,
  }) async {
    await _setSaving(true);
    try {
      final success = await action();
      if (success && applyMutation != null && _donation != null) {
        _donation = applyMutation(_donation!);
      }
      if (success) {
        emitCustom(const ExternalDonationHistoryDetailCustom.mutationSucceeded());
      } else {
        emitCustom(
          const ExternalDonationHistoryDetailCustom.mutationFailed(
            'mutation_failed',
          ),
        );
      }
    } catch (error) {
      emitCustom(
        ExternalDonationHistoryDetailCustom.mutationFailed(error.toString()),
      );
    } finally {
      await _setSaving(false);
    }
  }

  Future<void> _setSaving(bool isSaving) async {
    if (isClosed) {
      return;
    }
    final donation = _donation;
    if (donation != null) {
      emitData(
        ExternalDonationHistoryDetailUIModel(
          donation: donation,
          isSaving: isSaving,
        ),
      );
    }
  }
}
