import 'package:givt_app/features/family/features/impact_groups/model/impact_group.dart';
import 'package:givt_app/features/family/network/api_service.dart';

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
