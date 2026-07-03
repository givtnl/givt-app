import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

/// Loads pledges for the overview screen.
///
/// Uses [GivtRepository.fetchPledges] (`GET /givtservice/v1/Pledge`).
mixin PledgesOverviewRepository {
  bool isLoading();

  String? getError();

  List<Pledge> getPledges();

  Future<void> loadPledges();
}

class PledgesOverviewRepositoryImpl with PledgesOverviewRepository {
  PledgesOverviewRepositoryImpl(this._givtRepository);

  final GivtRepository _givtRepository;

  List<Pledge> _pledges = const [];
  bool _isLoading = false;
  String? _error;

  @override
  bool isLoading() => _isLoading;

  @override
  String? getError() => _error;

  @override
  List<Pledge> getPledges() => _pledges;

  @override
  Future<void> loadPledges() async {
    _isLoading = true;
    _error = null;

    try {
      _pledges = await _givtRepository.fetchPledges();
      _error = null;
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
    }
  }
}
