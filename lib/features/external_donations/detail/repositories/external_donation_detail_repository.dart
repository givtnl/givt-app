import 'package:givt_app/features/external_donations/detail/models/external_donation_history_item.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_history_builder.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
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

  @override
  Future<bool> stopDonation(String externalDonationId) async {
    return _givtRepository.stopExternalDonation(externalDonationId);
  }
}
