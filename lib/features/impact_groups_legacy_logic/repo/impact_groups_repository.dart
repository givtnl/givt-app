// ignore_for_file: prefer_single_quotes

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/family_goal/repositories/create_family_goal_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/family/features/parental_approval/repositories/parental_approval_repository.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin ImpactGroupsRepository {
  Future<void> acceptGroupInvite({
    required String groupId,
  });

  Future<List<ImpactGroup>> getImpactGroups({bool fetchWhenEmpty = false});

  Future<String?> getFamilyGroupName();

  // this method should only be called externally when the screen itself
  // has a refresh mechanism for the user
  Future<List<ImpactGroup>> refreshImpactGroups();

  Future<ImpactGroup?> isInvitedToGroup();

  Future<bool> setBoxOrigin(String churchId);

  Future<Organisation?> getBoxOrigin();

  Future<void> setBoxOriginModalShown();

  Future<bool> wasBoxOriginModalShown();

  void clearBoxOriginModalShown();

  Stream<List<ImpactGroup>> onImpactGroupsChanged();
}

class ImpactGroupsRepositoryImpl with ImpactGroupsRepository {
  ImpactGroupsRepositoryImpl(
    this._apiService,
    this._createFamilyGoalRepository,
    this._parentalApprovalRepository,
    this._createTransactionRepository,
    this._authRepository,
    this._prefs,
  ) {
    _init();
  }

  final APIService _apiService;
  final CreateFamilyGoalRepository _createFamilyGoalRepository;
  final ParentalApprovalRepository _parentalApprovalRepository;
  final CreateTransactionRepository _createTransactionRepository;
  final FamilyAuthRepository _authRepository;
  final SharedPreferences _prefs;

  final String boxOriginModalShownKey = 'boxOriginModalShown';

  final StreamController<List<ImpactGroup>> _impactGroupsStreamController =
      StreamController.broadcast();

  List<ImpactGroup>? _impactGroups;

  Future<void> _init() async {
    _createFamilyGoalRepository.onFamilyGoalCreated().listen(
          (_) => _fetchImpactGroups(),
        );
    _parentalApprovalRepository.onParentalApprovalChanged().listen(
          (_) => _fetchImpactGroups(),
        );
    _createTransactionRepository.onTransactionByUser().listen(
          (_) => _fetchImpactGroups(),
        );
    _authRepository.authenticatedUserStream().listen(
      (userExt) {
        if (userExt != null) {
          _clearData();
          _fetchImpactGroups();
        } else {
          _clearData();
        }
      },
    );
  }

  void _clearData() {
    _impactGroups = null;
    _update([]);
  }

  @override
  Future<void> acceptGroupInvite({
    required String groupId,
  }) async {
    await _apiService.acceptGroupInvite(groupId);
    await _fetchImpactGroups();
    unawaited(_authRepository.onRegistrationFinished());
  }

  @override
  Future<List<ImpactGroup>> getImpactGroups(
      {bool fetchWhenEmpty = false}) async {
    if (fetchWhenEmpty && true == _impactGroups?.isEmpty) {
      _impactGroups = await _fetchImpactGroups();
    }
    return _impactGroups ??= await _fetchImpactGroups();
  }

  Future<List<ImpactGroup>> _fetchImpactGroups() async {
    final result = await _apiService.fetchImpactGroups();
    final list = result
        .map((e) => ImpactGroup.fromMap(e as Map<String, dynamic>))
        .toList();
    _update(list);
    return list;
  }

  void _update(List<ImpactGroup> newGroups) {
    if (!const ListEquality<ImpactGroup>().equals(newGroups, _impactGroups)) {
      _impactGroups = newGroups;
      _impactGroupsStreamController.add(newGroups);
    }
  }

  @override
  Stream<List<ImpactGroup>> onImpactGroupsChanged() =>
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
  Future<bool> setBoxOrigin(String churchMediumId) async {
    try {
      await getImpactGroups(fetchWhenEmpty: true);
      await _apiService.setBoxOrigin(
        orgId: churchMediumId,
        groupId: _impactGroups!.firstWhere(
          (element) => element.type == ImpactGroupType.family,
          orElse: () {
            throw Exception('No family group found');
          },
        ).id,
      );
      await _fetchImpactGroups();
      return true;
    } catch (e) {
      LoggingInfo.instance.error(
        'Error setting box origin: $e',
      );
      return false;
    }
  }

  @override
  Future<void> setBoxOriginModalShown() async {
    await _prefs.setBool(boxOriginModalShownKey, true);
  }

  @override
  Future<bool> wasBoxOriginModalShown() async {
    return _prefs.getBool(boxOriginModalShownKey) ?? false;
  }

  @override
  void clearBoxOriginModalShown() {
    _prefs.remove(boxOriginModalShownKey);
  }

  @override
  Future<Organisation?> getBoxOrigin() async {
    try {
      if (_impactGroups == null || _impactGroups!.isEmpty) {
        await getImpactGroups(fetchWhenEmpty: true);
      }
      return _impactGroups
              ?.firstWhere((element) => element.type == ImpactGroupType.family)
              .boxOrigin;
    } catch (e) {
      LoggingInfo.instance
          .error('No family group found when getting preferred church');
      return null;
    }
  }

  @override
  Future<List<ImpactGroup>> refreshImpactGroups() => _fetchImpactGroups();

  @override
  Future<String?> getFamilyGroupName() async {
    return _impactGroups
            ?.firstWhereOrNull(
              (element) => element.isFamilyGroup,
            )
            ?.name ??
        await _fetchImpactGroups().then(
          (value) => value
              .firstWhereOrNull(
                (element) => element.isFamilyGroup,
              )
              ?.name,
        );
  }
}
