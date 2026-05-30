import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

/// Loads external donations for the overview screen.
///
/// **API contract (ENG-652 spike):**
/// - Overview uses `GET /givtservice/v1/externaldonations` ([GivtRepository.fetchExternalDonations]).
/// - Occurrence history uses `POST .../externaldonations/transactions/search` with
///   `{ startDate, endDate }` only — no documented parent-id filter yet (see detail repo).
/// - Stop recording has no dedicated client endpoint; treat as unavailable until backend
///   confirms whether `PUT` with `active: false` is the contract.
mixin ExternalDonationsOverviewRepository {
  bool isLoading();

  String? getError();

  List<ExternalDonation> getDonations();

  Future<void> loadDonations();
}

class ExternalDonationsOverviewRepositoryImpl
    with ExternalDonationsOverviewRepository {
  ExternalDonationsOverviewRepositoryImpl(this._givtRepository);

  final GivtRepository _givtRepository;

  List<ExternalDonation> _donations = const [];
  bool _isLoading = false;
  String? _error;

  @override
  bool isLoading() => _isLoading;

  @override
  String? getError() => _error;

  @override
  List<ExternalDonation> getDonations() => _donations;

  @override
  Future<void> loadDonations() async {
    _isLoading = true;
    _error = null;

    try {
      _donations = await _givtRepository.fetchExternalDonations();
      _error = null;
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
    }
  }
}
