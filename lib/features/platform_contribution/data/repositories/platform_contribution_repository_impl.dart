import 'dart:async';
import 'package:givt_app/features/platform_contribution/domain/models/platform_contribution_organization.dart';
import 'package:givt_app/features/platform_contribution/domain/models/platform_contribution_settings.dart';
import 'package:givt_app/features/platform_contribution/domain/repositories/platform_contribution_repository.dart';

/// Implementation of platform contribution repository with mock data
class PlatformContributionRepositoryImpl implements PlatformContributionRepository {
  PlatformContributionRepositoryImpl() {
    _initializeMockData();
  }

  final StreamController<PlatformContributionSettings> _settingsController =
      StreamController<PlatformContributionSettings>.broadcast();

  late PlatformContributionSettings _currentSettings;
  late PlatformContributionSettings _originalSettings;

  void _initializeMockData() {
        final organizations = [
          const PlatformContributionOrganization(
            id: 'presbyterian_church',
            name: 'Presbyterian Church',
            iconPath: 'assets/images/home_with_heart.svg',
            isEnabled: true,
            contributionLevel: PlatformContributionLevel.extraGenerous,
          ),
          const PlatformContributionOrganization(
            id: 'red_cross',
            name: 'Red Cross',
            iconPath: 'assets/images/coins.svg',
            isEnabled: false,
            contributionLevel: PlatformContributionLevel.mostPopular,
          ),
          const PlatformContributionOrganization(
            id: 'the_park_church',
            name: 'The Park Church',
            iconPath: 'assets/images/home_with_heart.svg',
            isEnabled: true,
            contributionLevel: PlatformContributionLevel.mostPopular,
          ),
        ];

    _originalSettings = PlatformContributionSettings(
      organizations: organizations,
      hasChanges: false,
    );

    _currentSettings = _originalSettings.copyWith();
  }

  @override
  Future<PlatformContributionSettings> getSettings() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _currentSettings;
  }

  @override
  Future<void> updateOrganizationSettings({
    required String organizationId,
    required bool isEnabled,
    PlatformContributionLevel? contributionLevel,
  }) async {
    final updatedOrganizations = _currentSettings.organizations.map((org) {
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
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    
    _originalSettings = _currentSettings.copyWith(hasChanges: false);
    _currentSettings = _originalSettings.copyWith();
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

  bool _hasChanges(List<PlatformContributionOrganization> organizations) {
    for (int i = 0; i < organizations.length; i++) {
      final current = organizations[i];
      final original = _originalSettings.organizations[i];
      
      if (current.isEnabled != original.isEnabled ||
          current.contributionLevel != original.contributionLevel) {
        return true;
      }
    }
    return false;
  }

  void dispose() {
    _settingsController.close();
  }
}
