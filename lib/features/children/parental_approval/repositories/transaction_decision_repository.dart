import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/children/parental_approval/models/decision_response.dart';

mixin TransactionDecisionRepository {
  Future<DecisionResponse> submitDecision({
    required int donationId,
    required String childId,
    required bool approved,
  });
}

class TransactionDecisionRepositoryImpl with TransactionDecisionRepository {
  TransactionDecisionRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<DecisionResponse> submitDecision({
    required int donationId,
    required String childId,
    required bool approved,
  }) async {
    final response = await _apiService.submitChildTransactionDecision(
      childId: childId,
      body: {
        'donationId': donationId,
        'approved': approved,
      },
    );

    final result = DecisionResponse.fromMap(response);
    return result;
  }
}
