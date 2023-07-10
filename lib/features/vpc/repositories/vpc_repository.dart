import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/vpc/models/vps_response.dart';

mixin VPCRepository {
  Future<VPCResponse> getVerifiableParentalConsentURL(String email);
}

class VPCRepositoryImpl with VPCRepository {
  VPCRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<VPCResponse> getVerifiableParentalConsentURL(String email) async {
    final response = await apiService.getVerifiableParentalConsentURL(email);
    final vpcResponse = VPCResponse.fromJson(response);
    return vpcResponse;
  }
}
