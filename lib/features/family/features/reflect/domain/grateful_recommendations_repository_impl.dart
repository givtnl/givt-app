import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/domain/grateful_recommendations_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/network/api_service.dart';

class GratefulRecommendationsRepositoryImpl
    implements GratefulRecommendationsRepository {
  GratefulRecommendationsRepositoryImpl(
    this._familyApiService,
  );

  final FamilyAPIService _familyApiService;
  final Map<GameProfile, List<Organisation>> _gratefulRecommendations = {};

  @override
  Future<void> fetchGratefulRecommendationsForMultipleProfiles(
    List<GameProfile> profiles,
  ) async {
    try {
      final results = await Future.wait(
        profiles.map((profile) async {
          final orgsList = await _getOrganisationsForProfile(profile);
          final sortedList = sortOrganisationsByChurchTag(orgsList);
          return MapEntry(profile, sortedList);
        }),
      );

      _gratefulRecommendations.addEntries(results);
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
    }
  }

  List<Organisation> sortOrganisationsByChurchTag(
      List<Organisation> organisations) {
    organisations.sort((a, b) {
      final aHasChurchTag = a.tags.any((tag) => tag.key == "CHURCH");
      final bHasChurchTag = b.tags.any((tag) => tag.key == "CHURCH");
      if (aHasChurchTag && !bHasChurchTag) {
        return -1;
      } else if (!aHasChurchTag && bHasChurchTag) {
        return 1;
      } else {
        return 0;
      }
    });
    return organisations;
  }

  Future<List<Organisation>> _getOrganisationsForProfile(
      GameProfile profile) async {
    final interests = profile.gratitude?.tags;
    final response = await _familyApiService.getRecommendedOrganisations(
      {
        'pageSize': 10,
        'tags': interests?.map((tag) => tag.key).toList(),
        'includePreferredChurch': true,
      },
    );

    final orgsList = response
        .map((org) => Organisation.fromMap(org as Map<String, dynamic>));
    return orgsList.toList();
  }

  @override
  Future<List<Organisation>> getGratefulRecommendations(
    GameProfile profile,
  ) async {
    if (!_gratefulRecommendations.containsKey(profile)) {
      final result = await _getOrganisationsForProfile(profile);
      final sortedList = sortOrganisationsByChurchTag(result);
      _gratefulRecommendations[profile] = sortedList;
    }

    return _gratefulRecommendations[profile] ?? [];
  }
}
