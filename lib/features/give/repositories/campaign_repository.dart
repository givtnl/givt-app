import 'dart:convert';
import 'dart:io';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin CampaignRepository {
  Future<Organisation> getOrganisation(String mediumId);
  Future<bool> saveLastDonation(Organisation organisation);
  Future<Organisation> getLastOrganisationDonated();
  Future<Organisation> getCachedOrganisation(String mediumId);
}

class CampaignRepositoryImpl with CampaignRepository {
  CampaignRepositoryImpl(
    this.apiService,
    this.prefs,
  );
  final APIService apiService;
  final SharedPreferences prefs;

  @override
  Future<Organisation> getCachedOrganisation(String mediumId) async {
    final collectGroup = (await _getCollectGroupList()).firstWhere(
      (collectGroup) => mediumId.contains(collectGroup.nameSpace),
      orElse: CollectGroup.empty,
    );

    return Organisation(
      organisationName: collectGroup.orgName,
      mediumId: collectGroup.nameSpace,
    );
  }

  @override
  Future<Organisation> getOrganisation(String mediumId) async {
    try {
      final response = await apiService.getOrganisationDetailsFromMedium(
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

  @override
  Future<bool> saveLastDonation(Organisation organisation) async {
    return prefs.setString(
      Organisation.lastOrganisationDonatedKey,
      jsonEncode(
        organisation.toJson(),
      ),
    );
  }

  @override
  Future<Organisation> getLastOrganisationDonated() async {
    final lastDonation = prefs.getString(
      Organisation.lastOrganisationDonatedKey,
    );
    if (lastDonation == null) {
      return const Organisation.empty();
    }
    final organisation = Organisation.fromJson(
      jsonDecode(
        lastDonation,
      ) as Map<String, dynamic>,
    );
    final cachedCollectGroup = (await _getCollectGroupList()).firstWhere(
      (collectGroup) => organisation.mediumId!.contains(collectGroup.nameSpace),
      orElse: CollectGroup.empty,
    );

    if (cachedCollectGroup.orgName != organisation.organisationName) {
      return organisation.copyWith(
        organisationName: cachedCollectGroup.orgName,
      );
    }
    return organisation;
  }

  Future<List<CollectGroup>> _getCollectGroupList() async {
    final collectGroupList = prefs.getStringList(
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
}
