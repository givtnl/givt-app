import 'package:givt_app/features/external_donations/detail/models/external_donation_history_item.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_payload.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_scope.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_history_builder.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

/// Repository for a single external donation detail view.
///
/// One-off detail uses [ExternalDonation.startDateTime] only (no transactions).
///
/// Recurring history uses [GivtRepository.fetchExternalDonationTransactions]
/// and [ExternalDonationHistoryBuilder].
///
/// Stop uses `POST /givtservice/v1/ExternalDonations/{id}/stop`.
mixin ExternalDonationDetailRepository {
  bool isLoading();

  String? getError();

  ExternalDonation? getDonation();

  Future<void> loadDetail(ExternalDonation donation);

  double getTotalDonated();

  GivingDuration? getGivingDuration();

  List<ExternalDonationHistoryItem> getHistory();

  Future<bool> stopDonation(String externalDonationId);

  Future<bool> updateAmount({
    required String externalDonationId,
    required double amount,
    ExternalDonationUpdateScope? scope,
  });

  Future<bool> updateFrequency({
    required String externalDonationId,
    required ExternalDonationFrequency frequency,
    required DateTime anchorDate,
    ExternalDonationUpdateScope? scope,
  });

  Future<bool> updateStartDate({
    required String externalDonationId,
    required DateTime startDate,
  });

  Future<bool> updateOneOff({
    required String externalDonationId,
    double? amount,
    DateTime? date,
  });

  Future<bool> deleteDonation(String externalDonationId);

  Future<bool> bulkUpdateTransactions({
    required List<String> transactionIds,
    required double newAmount,
  });

  Future<bool> bulkDeleteTransactions({
    required List<String> transactionIds,
  });
}

class ExternalDonationDetailRepositoryImpl
    with ExternalDonationDetailRepository {
  ExternalDonationDetailRepositoryImpl(this._givtRepository);

  final GivtRepository _givtRepository;

  ExternalDonation? _donation;
  List<ExternalDonationHistoryItem> _history = const [];
  double _totalDonated = 0;
  GivingDuration? _givingDuration;
  bool _isLoading = false;
  String? _error;

  @override
  bool isLoading() => _isLoading;

  @override
  String? getError() => _error;

  @override
  ExternalDonation? getDonation() => _donation;

  @override
  double getTotalDonated() => _totalDonated;

  @override
  GivingDuration? getGivingDuration() => _givingDuration;

  @override
  List<ExternalDonationHistoryItem> getHistory() => _history;

  @override
  Future<void> loadDetail(ExternalDonation donation) async {
    _donation = donation;
    _history = const [];
    _totalDonated = 0;
    _givingDuration = null;
    _isLoading = true;
    _error = null;

    try {
      if (donation.isOneOff) {
        _totalDonated = donation.amount;
        return;
      }

      final transactions =
          await _givtRepository.fetchExternalDonationTransactions(donation.id);

      final detail = ExternalDonationHistoryBuilder.build(
        donation: donation,
        transactions: transactions,
        now: DateTime.now(),
      );

      _totalDonated = detail.totalDonated;
      _givingDuration = detail.givingDuration;
      _history = detail.history;
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _reloadCurrentDonation() async {
    final current = _donation;
    if (current == null) {
      return;
    }

    // Use the list endpoint so `active` and other summary fields stay correct.
    // `GET …/details` omits `Active` in the BFF mapping (serializes as false).
    final donations = await _givtRepository.fetchExternalDonations();
    ExternalDonation? refreshed;
    for (final donation in donations) {
      if (donation.id == current.id) {
        refreshed = donation;
        break;
      }
    }

    await loadDetail(refreshed ?? current);
  }

  @override
  Future<bool> stopDonation(String externalDonationId) async {
    return _givtRepository.stopExternalDonation(externalDonationId);
  }

  @override
  Future<bool> updateAmount({
    required String externalDonationId,
    required double amount,
    ExternalDonationUpdateScope? scope,
  }) async {
    final success = await _givtRepository.updateExternalDonation(
      id: externalDonationId,
      body: ExternalDonationUpdatePayload.amount(
        amount: amount,
        scope: scope,
      ),
    );
    if (success) {
      await _reloadCurrentDonation();
    }
    return success;
  }

  @override
  Future<bool> updateFrequency({
    required String externalDonationId,
    required ExternalDonationFrequency frequency,
    required DateTime anchorDate,
    ExternalDonationUpdateScope? scope,
  }) async {
    final success = await _givtRepository.updateExternalDonation(
      id: externalDonationId,
      body: ExternalDonationUpdatePayload.frequency(
        frequency: frequency,
        anchorDate: anchorDate,
        scope: scope,
      ),
    );
    if (success) {
      await _reloadCurrentDonation();
    }
    return success;
  }

  @override
  Future<bool> updateStartDate({
    required String externalDonationId,
    required DateTime startDate,
  }) async {
    final success = await _givtRepository.updateExternalDonation(
      id: externalDonationId,
      body: ExternalDonationUpdatePayload.startDate(startDate: startDate),
    );
    if (success) {
      await _reloadCurrentDonation();
    }
    return success;
  }

  @override
  Future<bool> updateOneOff({
    required String externalDonationId,
    double? amount,
    DateTime? date,
  }) async {
    final success = await _givtRepository.updateExternalDonation(
      id: externalDonationId,
      body: ExternalDonationUpdatePayload.oneOffDate(
        amount: amount,
        date: date ?? _donation?.startDateTime ?? DateTime.now(),
      ),
    );
    if (success) {
      await _reloadCurrentDonation();
    }
    return success;
  }

  @override
  Future<bool> deleteDonation(String externalDonationId) async {
    return _givtRepository.deleteExternalDonation(externalDonationId);
  }

  @override
  Future<bool> bulkUpdateTransactions({
    required List<String> transactionIds,
    required double newAmount,
  }) async {
    final success = await _givtRepository.bulkUpdateExternalDonationTransactions(
      transactionIds: transactionIds,
      newAmount: newAmount,
    );
    if (success) {
      await _reloadCurrentDonation();
    }
    return success;
  }

  @override
  Future<bool> bulkDeleteTransactions({
    required List<String> transactionIds,
  }) async {
    final success = await _givtRepository.bulkDeleteExternalDonationTransactions(
      transactionIds: transactionIds,
    );
    if (success) {
      await _reloadCurrentDonation();
    }
    return success;
  }
}
