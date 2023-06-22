import 'package:givt_app/core/network/api_service.dart';

mixin InfraRepository {
  Future<bool> contactSupport({
    required String name,
    required String email,
    required String message,
  });
}

class InfraRepositoryImpl with InfraRepository {
  const InfraRepositoryImpl(this.apiClient);

  final APIService apiClient;

  @override
  Future<bool> contactSupport({
    required String name,
    required String email,
    required String message,
  }) async =>
      apiClient.contactSupport(
        {
          'guid': name,
          'subject': email,
          'message': message,
        },
      );
}
