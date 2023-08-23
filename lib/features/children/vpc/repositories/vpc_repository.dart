import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/vpc/models/vps_response.dart';

mixin VPCRepository {
  Future<VPCResponse> getVerifiableParentalConsentURL(String guid);
}

class VPCRepositoryImpl with VPCRepository {
  VPCRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<VPCResponse> getVerifiableParentalConsentURL(String guid) async {
    final response = await apiService.getVerifiableParentalConsentURL(guid);
    final vpcResponse = VPCResponse.fromJson(response);
    return vpcResponse;
  }
}
