import 'dart:async';

import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/platform_contribution/domain/models/platform_contribution_organization.dart';
import 'package:givt_app/features/platform_contribution/domain/models/platform_contribution_settings.dart';
import 'package:givt_app/features/platform_contribution/domain/repositories/platform_contribution_repository.dart';

/// Implementation of platform contribution repository backed by API
class PlatformContributionRepositoryImpl
    implements PlatformContributionRepository {
  PlatformContributionRepositoryImpl(this._apiService) {
    _settingsController =
        StreamController<PlatformContributionSettings>.broadcast();
  }

  final APIService _apiService;
  late StreamController<PlatformContributionSettings> _settingsController;

  late PlatformContributionSettings _currentSettings;
  late PlatformContributionSettings _originalSettings;

  @override
  Future<PlatformContributionSettings> getSettings() async {
    // Load from API
    final items = await _apiService.getPlatformFeePreferences();

    // Map API items to domain organizations; use API response fields directly
    final organizations = items
        .map((dynamic item) {
          final map = item as Map<String, dynamic>;
          final collectGroupId = map['collectGroupId'] as String;
          final collectGroupName =
              map['collectGroupName'] as String? ?? 'Unknown';
          final collectGroupTypeString =
              map['collectGroupType'] as String? ?? '';
          final collectGroupType = CollectGroupType.fromString(
            collectGroupTypeString,
          );
          final level = _mapApiFeeTypeToDomain(
            map['platformFeeType'] as String?,
          );
          final active = map['active'] as bool? ?? true;

          return PlatformContributionOrganization(
            id: collectGroupId,
            name: collectGroupName,
            type: collectGroupType,
            isEnabled: active,
            contributionLevel: level,
            preferenceId: map['id'] as String?,
          );
        })
        .cast<PlatformContributionOrganization>()
        .toList();

    _originalSettings = PlatformContributionSettings(
      organizations: organizations,
      hasChanges: false,
    );
    _currentSettings = _originalSettings;

    return _currentSettings;
  }

  @override
  Future<void> updateOrganizationSettings({
    required String organizationId,
    required bool isEnabled,
    PlatformContributionLevel? contributionLevel,
  }) async {
    final updatedOrganizations = _ensureCurrentInitialized().organizations.map((
      org,
    ) {
      if (org.id == organizationId) {
        return org.copyWith(
          isEnabled: isEnabled,
          contributionLevel: contributionLevel ?? org.contributionLevel,
        );
      }
      return org;
    }).toList();

    _currentSettings = _currentSettings.copyWith(
      organizations: updatedOrganizations,
      hasChanges: _hasChanges(updatedOrganizations),
    );
    _settingsController.add(_currentSettings);
  }

  @override
  Future<void> saveChanges() async {
    // Determine diffs and call API
    for (final current in _currentSettings.organizations) {
      final original = _originalSettings.organizations.firstWhere(
        (o) => o.id == current.id,
        orElse: () => current,
      );

      final typeChanged =
          current.contributionLevel != original.contributionLevel;
      final activeChanged = current.isEnabled != original.isEnabled;

      if (current.preferenceId == null && current.isEnabled) {
        // Create preference
        await _apiService.createPlatformFeePreference({
          'collectGroupId': current.id,
          'platformFeeType': _mapDomainLevelToApi(current.contributionLevel),
        });
        continue;
      }

      if (current.preferenceId != null && (typeChanged || activeChanged)) {
        await _apiService.updatePlatformFeePreference(
          current.preferenceId!,
          {
            'platformFeeType': _mapDomainLevelToApi(current.contributionLevel),
            'active': current.isEnabled,
          },
        );
      }
    }

    // Reload latest from server
    await getSettings();
    _settingsController.add(_currentSettings);
  }

  @override
  Future<void> discardChanges() async {
    _currentSettings = _originalSettings.copyWith();
    _settingsController.add(_currentSettings);
  }

  @override
  Stream<PlatformContributionSettings> onSettingsChanged() {
    return _settingsController.stream;
  }

  PlatformContributionSettings _ensureCurrentInitialized() {
    return _currentSettings;
  }

  bool _hasChanges(List<PlatformContributionOrganization> organizations) {
    if (_originalSettings.organizations.length != organizations.length) {
      return true;
    }
    for (final current in organizations) {
      final original = _originalSettings.organizations.firstWhere(
        (o) => o.id == current.id,
        orElse: () => current,
      );
      if (current.isEnabled != original.isEnabled ||
          current.contributionLevel != original.contributionLevel) {
        return true;
      }
    }
    return false;
  }

  PlatformContributionLevel _mapApiFeeTypeToDomain(String? type) {
    switch ((type ?? '').toLowerCase()) {
      case 'common':
        return PlatformContributionLevel.common;
      case 'generous':
        return PlatformContributionLevel.generous;
      default:
        return PlatformContributionLevel.common;
    }
  }

  String _mapDomainLevelToApi(PlatformContributionLevel level) {
    switch (level) {
      case PlatformContributionLevel.common:
        return 'common';
      case PlatformContributionLevel.generous:
        return 'generous';
    }
  }

  void dispose() {
    _settingsController.close();
  }
}
