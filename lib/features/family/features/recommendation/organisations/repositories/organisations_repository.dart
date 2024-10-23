import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

mixin OrganisationsRepository {
  Future<List<Organisation>> getRecommendedOrganisations({
    required Tag location,
    required List<Tag> interests,
    required int pageSize,
    required bool filterInterests,
    required String cityName,
  });
}

class OrganisationsRepositoryImpl with OrganisationsRepository {
  OrganisationsRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;

  @override
  Future<List<Organisation>> getRecommendedOrganisations({
    required Tag location,
    required List<Tag> interests,
    required int pageSize,
    required bool filterInterests,
    required String cityName,
  }) async {
    final response = await _apiService.getRecommendedOrganisations(
      {
        'range': location.key,
        'pageSize': pageSize,
        'tags': interests.map((interest) => interest.key).toList(),
        'city': cityName,
      },
    );

    final result = <Organisation>[];
    for (final organisationMap in response) {
      final org = Organisation.fromMap(organisationMap as Map<String, dynamic>);
      if (filterInterests) {
        org.tags.removeWhere(
          (tag) =>
              !interests.contains(tag) && tag.type == TagType.INTERESTS ||
              location.key != tag.key && tag.type == TagType.LOCATION,
        );
      }
      result.add(org);
    }
    return result;
  }
}
