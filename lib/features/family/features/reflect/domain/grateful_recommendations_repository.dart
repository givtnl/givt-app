import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

abstract class GratefulRecommendationsRepository {
  Future<void> fetchGratefulRecommendationsForMultipleProfiles(
    List<GameProfile> profiles,
  );

  Future<List<Organisation>> getOrganisationsRecommendations(
    GameProfile profile,
  );

  Future<List<Organisation>> getActsRecommendations(
    GameProfile profile,
  );
}
