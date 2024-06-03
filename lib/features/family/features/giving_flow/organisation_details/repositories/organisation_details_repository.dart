
import 'package:givt_app/features/family/features/giving_flow/organisation_details/models/organisation_details.dart';
import 'package:givt_app/features/family/network/api_service.dart';

mixin OrganisationDetailsRepository {
  Future<OrganisationDetails> fetchOrganisationDetails(String mediumId);
}

class OrganisationDetailsRepositoryImpl with OrganisationDetailsRepository {
  OrganisationDetailsRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<OrganisationDetails> fetchOrganisationDetails(String mediumId) async {
    final response = await _apiService.fetchOrganisationDetails(mediumId);
    return OrganisationDetails.fromMap(response);
  }
}
