import 'package:givt_app/features/external_donations/detail/models/external_donation_history_item.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

/// Repository for a single external donation detail view.
///
/// One-off detail uses fields on [ExternalDonation] only (no transactions call).
///
/// Recurring history uses [GivtRepository.fetchExternalDonationTransactions]
/// (`GET .../externaldonations/{id}/transactions`).
///
/// Stop uses [stopDonation] → `POST /givtservice/v1/ExternalDonations/{id}/stop`.
mixin ExternalDonationDetailRepository {
  bool isLoading();

  String? getError();

  ExternalDonation? getDonation();

  Future<void> loadDetail(ExternalDonation donation);

  double getTotalDonated();

  GivingDuration? getGivingDuration();

  DateTime? getOneOffTransactionDate();

  List<ExternalDonationHistoryItem> getHistory();

  bool get isRecurring;

  bool get isActive;

  Future<bool> stopDonation(String externalDonationId);
}

class ExternalDonationDetailRepositoryImpl with ExternalDonationDetailRepository {
  ExternalDonationDetailRepositoryImpl(this._givtRepository);

  final GivtRepository _givtRepository;

  ExternalDonation? _donation;
  List<ExternalDonationHistoryItem> _history = const [];
  double _totalDonated = 0;
  GivingDuration? _givingDuration;
  DateTime? _oneOffTransactionDate;
  bool _isLoading = false;
  String? _error;

  @override
  bool isLoading() => _isLoading;

  @override
  String? getError() => _error;

  @override
  ExternalDonation? getDonation() => _donation;

  @override
  bool get isRecurring =>
      _donation?.frequency != ExternalDonationFrequency.once;

  @override
  bool get isActive => _donation?.active ?? false;

  @override
  double getTotalDonated() => _totalDonated;

  @override
  GivingDuration? getGivingDuration() => _givingDuration;

  @override
  DateTime? getOneOffTransactionDate() => _oneOffTransactionDate;

  @override
  List<ExternalDonationHistoryItem> getHistory() => _history;

  @override
  Future<void> loadDetail(ExternalDonation donation) async {
    _donation = donation;
    _history = const [];
    _totalDonated = 0;
    _givingDuration = null;
    _oneOffTransactionDate = null;
    _isLoading = true;
    _error = null;

    try {
      final now = DateTime.now();
      final fallbackDate =
          DateTime.tryParse(donation.creationDate) ?? now;

      if (!isRecurring) {
        _totalDonated = donation.amount;
        _history = const [];
        _oneOffTransactionDate = fallbackDate;
        return;
      }

      final transactions = await _givtRepository.fetchExternalDonationTransactions(
        donation.id,
      );

      final recorded = <ExternalDonationHistoryItem>[];
      for (final transaction in transactions) {
        final date = DateTime.tryParse(transaction.creationDate);
        if (date == null) {
          continue;
        }
        if (date.isAfter(now)) {
          continue;
        }
        recorded.add(
          ExternalDonationHistoryItem(
            amount: transaction.amount,
            date: date,
            isUpcoming: false,
          ),
        );
      }

      recorded.sort((a, b) => b.date.compareTo(a.date));

      if (recorded.isEmpty) {
        recorded.add(
          ExternalDonationHistoryItem(
            amount: donation.amount,
            date: fallbackDate,
            isUpcoming: false,
          ),
        );
      }

      _totalDonated = recorded.fold<double>(
        0,
        (sum, item) => sum + item.amount,
      );

      final firstGivingDate = recorded.last.date;
      final lastGivingDate = recorded.first.date;
      final givingEndDate = isActive ? now : lastGivingDate;
      _givingDuration = givingDurationBetween(firstGivingDate, givingEndDate);

      var history = recorded;

      if (isActive) {
        final nextDate = donation.nextRecurringOccurrenceDate ??
            computeNextOccurrenceDate(
              startDate: fallbackDate,
              frequency: donation.frequency,
              after: now,
            );
        if (nextDate != null) {
          history = [
            ExternalDonationHistoryItem(
              amount: donation.amount,
              date: nextDate,
              isUpcoming: true,
            ),
            ...recorded,
          ];
        }
      }

      _history = history;
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
    }
  }

  @override
  Future<bool> stopDonation(String externalDonationId) async {
    return _givtRepository.stopExternalDonation(externalDonationId);
  }
}
