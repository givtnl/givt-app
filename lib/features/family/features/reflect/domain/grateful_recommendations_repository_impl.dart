import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/repositories/organisations_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/grateful_recommendations_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

class GratefulRecommendationsRepositoryImpl
    implements GratefulRecommendationsRepository {

  GratefulRecommendationsRepositoryImpl(this._organisationsRepository);

  final OrganisationsRepository _organisationsRepository;
  final Map<GameProfile, List<Organisation>> _gratefulRecommendations = {};

  @override
  Future<Map<GameProfile, List<Organisation>>>
      getGratefulRecommendationsForMultipleProfiles(
    List<GameProfile> profiles,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Organisation>> getGratefulRecommendations(
    GameProfile profile,
  ) async {
    return _gratefulRecommendations[profile] ?? []; //_organisationsRepository.getRecommendedOrganisations() instead of []
  }
}
