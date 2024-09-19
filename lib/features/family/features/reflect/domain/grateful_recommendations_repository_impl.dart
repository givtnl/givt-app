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
  Future<Map<GameProfile, List<Organisation>>>
      getGratefulRecommendationsForMultipleProfiles(
    List<GameProfile> profiles,
  ) async {
    final results = await Future.wait(
      profiles.map((profile) async {
        final interests = profile.gratitude?.tags;
        final response = await _familyApiService.getRecommendedOrganisations(
          {
            'pageSize': 10,
            'tags': interests?.map((tag) => tag.key).toList(),
          },
        );

        final orgsList = response
            .map((org) => Organisation.fromMap(org as Map<String, dynamic>));
        return MapEntry(profile, orgsList.toList());
      }),
    );

    _gratefulRecommendations.addEntries(results);
    return _gratefulRecommendations;
  }

  @override
  Future<List<Organisation>> getGratefulRecommendations(
    GameProfile profile,
  ) async {
    return _gratefulRecommendations[profile] ??
        (await getGratefulRecommendationsForMultipleProfiles([profile]))
            .values
            .first;
  }
}
