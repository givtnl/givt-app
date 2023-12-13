import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/shared/models/models.dart';

mixin InfraRepository {
  Future<bool> contactSupport({
    required String guid,
    required String message,
  });

  Future<AppUpdate?> checkAppUpdate({
    required String buildNumber,
  });
}

class InfraRepositoryImpl with InfraRepository {
  const InfraRepositoryImpl(this.apiClient);

  final APIService apiClient;

  @override
  Future<bool> contactSupport({
    required String guid,
    required String message,
  }) async =>
      apiClient.contactSupport(
        {
          'guid': guid,
          'subject': 'Feedback app',
          'message': message,
        },
      );

  @override
  Future<AppUpdate?> checkAppUpdate({
    required String buildNumber,
  }) async {
    final response = await apiClient.checkAppUpdate(
      {
        'buildNumber': buildNumber,
      },
    );

    if (response.isEmpty) {
      return null;
    }

    return AppUpdate.fromJson(response);
  }
}
