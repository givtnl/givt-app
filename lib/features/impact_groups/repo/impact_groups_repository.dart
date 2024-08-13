// ignore_for_file: prefer_single_quotes

import 'dart:async';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

mixin ImpactGroupsRepository {
  Future<void> acceptGroupInvite({
    required String groupId,
  });

  Future<List<ImpactGroup>> getImpactGroups();

  // this method should only be called externally when the screen itself
  // has a refresh mechanism for the user
  Future<List<ImpactGroup>> refreshImpactGroups();

  Future<ImpactGroup?> isInvitedToGroup();

  Stream<List<ImpactGroup>> impactGroupsStream();
}

class ImpactGroupsRepositoryImpl with ImpactGroupsRepository {
  ImpactGroupsRepositoryImpl(
    this._apiService,
      this._givtRepository,
  ) {
    _init();
  }

  final APIService _apiService;
  final GivtRepository _givtRepository;

  final StreamController<List<ImpactGroup>> _impactGroupsStreamController =
      StreamController.broadcast();

  List<ImpactGroup>? _impactGroups;

  Future<void> _init() async {
    _givtRepository.onGivtsChangedStream().listen(
          (_) => _fetchImpactGroups(),
        );
  }

  @override
  Future<void> acceptGroupInvite({
    required String groupId,
  }) async {
    await _apiService.acceptGroupInvite(groupId);
    await _fetchImpactGroups();
  }

  @override
  Future<List<ImpactGroup>> getImpactGroups() async {
    return _impactGroups ??= await _fetchImpactGroups();
  }

  Future<List<ImpactGroup>> _fetchImpactGroups() async {
    final result = await _apiService.fetchImpactGroups();
    final list = result
        .map((e) => ImpactGroup.fromMap(e as Map<String, dynamic>))
        .toList();
    _impactGroupsStreamController.add(list);
    return list;
  }

  @override
  Stream<List<ImpactGroup>> impactGroupsStream() =>
      _impactGroupsStreamController.stream;

  @override
  Future<ImpactGroup?> isInvitedToGroup() async {
    for (final impactGroup in await getImpactGroups()) {
      if (impactGroup.status == ImpactGroupStatus.invited) {
        return impactGroup;
      }
    }
    return null;
  }

  @override
  Future<List<ImpactGroup>> refreshImpactGroups() => _fetchImpactGroups();
}
