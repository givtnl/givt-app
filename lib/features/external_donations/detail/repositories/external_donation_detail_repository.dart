import 'package:givt_app/features/external_donations/detail/models/external_donation_history_item.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

/// Repository for a single external donation detail view.
///
/// History uses [GivtRepository.fetchExternalDonationSummary]
/// (`POST .../externaldonations/transactions/search`); occurrences are matched to
/// the parent donation client-side (see [_matchesParent]).
///
/// Stop uses [stopDonation] → `POST /givtservice/v1/ExternalDonations/{id}/stop`.
mixin ExternalDonationDetailRepository {
  bool isLoading();

  String? getError();

  ExternalDonation? getDonation();

  Future<void> loadDetail(ExternalDonation donation);

  double getTotalDonated();

  int getGivingDays();

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
  int _givingDays = 0;
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
  int getGivingDays() => _givingDays;

  @override
  List<ExternalDonationHistoryItem> getHistory() => _history;

  @override
  Future<void> loadDetail(ExternalDonation donation) async {
    _donation = donation;
    _history = const [];
    _totalDonated = 0;
    _givingDays = 0;
    _isLoading = true;
    _error = null;

    try {
      final startDate = DateTime.tryParse(donation.creationDate) ?? DateTime.now();
      final now = DateTime.now();
      _givingDays = givingDaysSince(startDate, now);

      if (!isRecurring) {
        _totalDonated = donation.amount;
        _history = const [];
        return;
      }

      final searchEnd = now.add(const Duration(days: 365));
      final occurrences = await _givtRepository.fetchExternalDonationSummary(
        fromDate: startDate.toIso8601String(),
        tillDate: searchEnd.toIso8601String(),
      );

      final matched = occurrences
          .where((item) => _matchesParent(item, donation))
          .toList();

      final recorded = <ExternalDonationHistoryItem>[];
      for (final occurrence in matched) {
        final date = DateTime.tryParse(occurrence.creationDate);
        if (date == null) {
          continue;
        }
        if (date.isAfter(now)) {
          continue;
        }
        recorded.add(
          ExternalDonationHistoryItem(
            amount: occurrence.amount,
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
            date: startDate,
            isUpcoming: false,
          ),
        );
      }

      _totalDonated = recorded.fold<double>(
        0,
        (sum, item) => sum + item.amount,
      );

      var history = recorded;

      if (isActive) {
        final nextDate = computeNextOccurrenceDate(
          startDate: startDate,
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

  bool _matchesParent(ExternalDonation occurrence, ExternalDonation parent) {
    if (occurrence.id == parent.id) {
      return true;
    }
    return occurrence.description == parent.description &&
        occurrence.frequency == parent.frequency;
  }
}
