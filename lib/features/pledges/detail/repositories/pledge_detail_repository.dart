import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

mixin PledgeDetailRepository {
  bool isLoading();

  String? getError();

  PledgeGroup? getPledgeGroup();

  Future<void> loadDetail(String pledgeGroupId);

  Future<bool> updatePledge({
    required String pledgeId,
    double? amount,
    String? frequency,
    String? type,
  });
}

class PledgeDetailRepositoryImpl with PledgeDetailRepository {
  PledgeDetailRepositoryImpl(this._givtRepository);

  final GivtRepository _givtRepository;

  PledgeGroup? _pledgeGroup;
  bool _isLoading = false;
  String? _error;

  @override
  bool isLoading() => _isLoading;

  @override
  String? getError() => _error;

  @override
  PledgeGroup? getPledgeGroup() => _pledgeGroup;

  @override
  Future<void> loadDetail(String pledgeGroupId) async {
    _isLoading = true;
    _error = null;

    try {
      _pledgeGroup = await _givtRepository.fetchPledgeGroupDetail(pledgeGroupId);
    } catch (error) {
      _error = error.toString();
      _pledgeGroup = null;
    } finally {
      _isLoading = false;
    }
  }

  @override
  Future<bool> updatePledge({
    required String pledgeId,
    double? amount,
    String? frequency,
    String? type,
  }) async {
    final body = <String, dynamic>{};
    if (amount != null) {
      body['amount'] = amount;
    }
    if (frequency != null) {
      body['frequency'] = frequency;
    }
    if (type != null) {
      body['type'] = type;
    }

    return _givtRepository.updatePledge(
      pledgeId: pledgeId,
      body: body,
    );
  }
}
