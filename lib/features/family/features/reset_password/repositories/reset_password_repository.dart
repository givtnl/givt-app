import 'package:givt_app/features/family/network/family_api_service.dart';

mixin ResetPasswordRepository {
  Future<bool> resetPassword(String email);
}

class ResetPasswordRepositoryImpl with ResetPasswordRepository {
  ResetPasswordRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;

  @override
  Future<bool> resetPassword(String email) {
    return _apiService.resetPassword(email);
  }
}
