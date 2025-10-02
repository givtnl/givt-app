import 'package:givt_app/core/network/api_service.dart';

mixin PasswordResetRepository {
  Future<bool> resetPassword(String code, String email, String newPassword);
}

class PasswordResetRepositoryImpl with PasswordResetRepository {
  PasswordResetRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<bool> resetPassword(String code, String email, String newPassword) {
    return _apiService.resetPasswordWithCode(code, email, newPassword);
  }
}