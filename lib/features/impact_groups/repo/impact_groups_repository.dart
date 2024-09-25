// ignore_for_file: prefer_single_quotes

import 'dart:async';

import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/family_goal/repositories/create_family_goal_repository.dart';
import 'package:givt_app/features/children/parental_approval/repositories/parental_approval_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin ImpactGroupsRepository {
  Future<void> acceptGroupInvite({
    required String groupId,
  });

  Future<List<ImpactGroup>> getImpactGroups();

  // this method should only be called externally when the screen itself
  // has a refresh mechanism for the user
  Future<List<ImpactGroup>> refreshImpactGroups();

  Future<ImpactGroup?> isInvitedToGroup();

  Future<bool> setPreferredChurch(String churchId);

  Organisation? getPreferredChurch();

  void setPreferredChurchModalShown();

  Future<bool> wasPreferredChurchModalShown();

  void clearPreferredChurchModalShown();

  Stream<List<ImpactGroup>> onImpactGroupsChanged();
}

class ImpactGroupsRepositoryImpl with ImpactGroupsRepository {
  ImpactGroupsRepositoryImpl(
    this._apiService,
    this._givtRepository,
    this._createFamilyGoalRepository,
    this._parentalApprovalRepository,
    this._authRepository,
    this._createTransactionRepository,
    this._prefs,
  ) {
    _init();
  }

  final APIService _apiService;
  final GivtRepository _givtRepository;
  final CreateFamilyGoalRepository _createFamilyGoalRepository;
  final ParentalApprovalRepository _parentalApprovalRepository;
  final AuthRepository _authRepository;
  final CreateTransactionRepository _createTransactionRepository;
  final SharedPreferences _prefs;

  final String preferredChurchModalShownKey = 'preferredChurchModalShown';

  final StreamController<List<ImpactGroup>> _impactGroupsStreamController =
      StreamController.broadcast();

  List<ImpactGroup>? _impactGroups;

  Future<void> _init() async {
    _givtRepository.onGivtsChanged().listen(
          (_) => _fetchImpactGroups(),
        );
    _createFamilyGoalRepository.onFamilyGoalCreated().listen(
          (_) => _fetchImpactGroups(),
        );
    _parentalApprovalRepository.onParentalApprovalChanged().listen(
          (_) => _fetchImpactGroups(),
        );
    _authRepository.hasSessionStream().listen(
      (hasSession) {
        if (hasSession) {
          _clearData();
          _fetchImpactGroups();
        } else {
          _clearData();
        }
      },
    );
    _createTransactionRepository.onTransaction().listen(
          (_) => _fetchImpactGroups(),
        );
  }

  void _clearData() {
    _impactGroups = null;
    _impactGroupsStreamController.add([]);
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
    _impactGroups = list;
    _impactGroupsStreamController.add(list);
    return list;
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
  Future<bool> setPreferredChurch(String churchMediumId) async {
    try {
      await _apiService.setPreferredChurch(
        churchMediumId: churchMediumId,
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
        'Error while setting preferred church: $e',
      );
      return false;
    }
  }

  @override
  void setPreferredChurchModalShown() {
    _prefs.setBool(preferredChurchModalShownKey, true);
  }

  @override
  Future<bool> wasPreferredChurchModalShown() async {
    return _prefs.getBool(preferredChurchModalShownKey) ?? false;
  }

  @override
  void clearPreferredChurchModalShown() {
    _prefs.remove(preferredChurchModalShownKey);
  }

  @override
  Organisation? getPreferredChurch() => _impactGroups?.firstWhere(
        (element) => element.type == ImpactGroupType.family,
        orElse: () {
          throw Exception('No family group found');
        },
      ).preferredChurch;

  @override
  Future<List<ImpactGroup>> refreshImpactGroups() => _fetchImpactGroups();
}
