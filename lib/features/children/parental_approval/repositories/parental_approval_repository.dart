import 'dart:async';

import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/children/parental_approval/models/parental_approval_response.dart';

mixin ParentalApprovalRepository {
  Future<ParentalApprovalResponse> submitDecision({
    required int donationId,
    required String childId,
    required bool approved,
  });

  Stream<ParentalApprovalResponse> onParentalApprovalChanged();
}

class ParentalApprovalRepositoryImpl with ParentalApprovalRepository {
  ParentalApprovalRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;
  final StreamController<ParentalApprovalResponse>
      _parentalApprovalStreamController = StreamController.broadcast();

  @override
  Future<ParentalApprovalResponse> submitDecision({
    required int donationId,
    required String childId,
    required bool approved,
  }) async {
    final response = await _apiService.submitParentalApprovalDecision(
      childId: childId,
      body: {
        'donationId': donationId,
        'approved': approved,
      },
    );

    final result = ParentalApprovalResponse.fromMap(response);
    _parentalApprovalStreamController.add(result);
    return result;
  }

  @override
  Stream<ParentalApprovalResponse> onParentalApprovalChanged() =>
      _parentalApprovalStreamController.stream;
}
