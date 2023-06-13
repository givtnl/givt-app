import 'dart:convert';
import 'dart:io';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignRepository {
  CampaignRepository(
    this._apiService,
    this._prefs,
  );
  final APIService _apiService;
  final SharedPreferences _prefs;

  Future<Organisation> getOrganisation(String mediumId) async {
    try {
      final response = await _apiService.getOrganisationDetailsFromMedium(
        {
          'code': mediumId,
        },
      );
      final organisation = Organisation.fromJson(response);
      return organisation;
    } on SocketException {
      final collectGroup = (await _getCollectGroupList()).firstWhere(
        (collectGroup) => mediumId.contains(collectGroup.nameSpace),
        orElse: CollectGroup.empty,
      );

      return Organisation(
        organisationName: collectGroup.orgName,
        mediumId: collectGroup.nameSpace,
      );
    }
  }

  Future<bool> saveLastDonation(Organisation organisation) async {
    return _prefs.setString(
      Organisation.lastOrganisationDonatedKey,
      jsonEncode(
        organisation.toJson(),
      ),
    );
  }

  Future<List<CollectGroup>> _getCollectGroupList() async {
    final collectGroupList = _prefs.getStringList(
      CollectGroup.orgBeaconListKey,
    );
    if (collectGroupList == null) {
      return <CollectGroup>[];
    }
    final collectGroups = collectGroupList
        .map(
          (e) => CollectGroup.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList();
    return collectGroups;
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
