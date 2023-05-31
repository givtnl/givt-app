import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/give/models/organisation.dart';

class CampaignRepository {
  CampaignRepository(
    this._apiService,
  );
  final APIService _apiService;

  Future<Organisation> getOrganisation(String mediumId) async {
    final response = await _apiService.getOrganisationDetailsFromMedium(
      {
        'code': mediumId,
      },
    );
    final organisation = Organisation.fromJson(response);
    return organisation;
  }
}
