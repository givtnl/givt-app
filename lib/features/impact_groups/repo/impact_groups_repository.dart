// ignore_for_file: prefer_single_quotes

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';

mixin ImpactGroupsRepository {
  Future<void> acceptGroupInvite({
    required String groupId,
  });
  Future<List<ImpactGroup>> fetchImpactGroups();
}

class ImpactGroupsRepositoryImpl with ImpactGroupsRepository {
  ImpactGroupsRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<void> acceptGroupInvite({
    required String groupId,
  }) async {
    await _apiService.acceptGroupInvite(groupId);
  }

  @override
  Future<List<ImpactGroup>> fetchImpactGroups() async {
    final result = await _apiService.fetchImpactGroups();
    return result
        .map((e) => ImpactGroup.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
