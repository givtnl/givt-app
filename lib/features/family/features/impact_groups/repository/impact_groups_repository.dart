import 'package:givt_app/features/family/network/family_api_service.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';

mixin ImpactGroupsRepository {
  Future<List<ImpactGroup>> fetchImpactGroups(String guid);
}

class ImpactGroupsRepositoryImpl with ImpactGroupsRepository {
  ImpactGroupsRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;

  @override
  Future<List<ImpactGroup>> fetchImpactGroups(String guid) async {
    final result = await _apiService.fetchImpactGroups(guid);
    return result
        .map((e) => ImpactGroup.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
