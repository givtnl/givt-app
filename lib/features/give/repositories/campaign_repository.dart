import 'dart:convert';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignRepository {
  CampaignRepository(
    this._apiService,
    this._prefs,
  );
  final APIService _apiService;
  final SharedPreferences _prefs;

  Future<Organisation> getOrganisation(String mediumId) async {
    final response = await _apiService.getOrganisationDetailsFromMedium(
      {
        'code': mediumId,
      },
    );
    final organisation = Organisation.fromJson(response);
    return organisation;
  }

  Future<bool> saveLastDonation(Organisation organisation) async {
    return _prefs.setString(
      Organisation.lastOrganisationDonatedKey,
      jsonEncode(
        organisation.toJson(),
      ),
    );
  }

  Future<Organisation> getLastOrganisationDonated() async {
    final lastDonation = _prefs.getString(
      Organisation.lastOrganisationDonatedKey,
    );
    if (lastDonation == null) {
      return Organisation.empty();
    }
    final organisation = Organisation.fromJson(
      jsonDecode(
        lastDonation,
      ) as Map<String, dynamic>,
    );
    return organisation;
  }
}
