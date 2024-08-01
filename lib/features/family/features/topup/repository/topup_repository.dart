import 'package:givt_app/features/family/network/api_service.dart';

mixin TopupRepository {
  Future<bool> topupChild(String childGUID, int amount);
}

class TopupRepositoryImpl with TopupRepository {
  TopupRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;

  @override
  Future<bool> topupChild(String childGUID, int amount) async {
    final response = await _apiService.topUpChild(childGUID, amount);
    return response;
  }
}
