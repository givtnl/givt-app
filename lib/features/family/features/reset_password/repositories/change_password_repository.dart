import 'package:givt_app/features/family/network/family_api_service.dart';

mixin ChangePasswordRepository {
  Future<bool> changePassword({
    required String userID,
    required String passwordToken,
    required String newPassword,
  });
}

class ChangePasswordRepositoryImpl with ChangePasswordRepository {
  ChangePasswordRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;

  @override
  Future<bool> changePassword({
    required String userID,
    required String passwordToken,
    required String newPassword,
  }) {
    return _apiService.changePassword(
      userID: userID,
      passwordToken: passwordToken,
      newPassword: newPassword,
    );
  }
}