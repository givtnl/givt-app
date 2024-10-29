import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/models/collectgroup_details.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

mixin OrganisationDetailsRepository {
  Future<CollectGroupDetails> fetchOrganisationDetails(String mediumId);
}

class OrganisationDetailsRepositoryImpl with OrganisationDetailsRepository {
  OrganisationDetailsRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;

  @override
  Future<CollectGroupDetails> fetchOrganisationDetails(String mediumId) async {
    final response = await _apiService.fetchOrganisationDetails(mediumId);
    return CollectGroupDetails.fromMap(response);
  }
}
