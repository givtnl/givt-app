import 'dart:async';
import '../models/platform_contribution_organization.dart';
import '../models/platform_contribution_settings.dart';

/// Repository interface for platform contribution data
abstract class PlatformContributionRepository {
  /// Get the current platform contribution settings
  Future<PlatformContributionSettings> getSettings();

  /// Update organization contribution settings
  Future<void> updateOrganizationSettings({
    required String organizationId,
    required bool isEnabled,
    PlatformContributionLevel? contributionLevel,
  });

  /// Save all changes
  Future<void> saveChanges();

  /// Discard all changes
  Future<void> discardChanges();

  /// Stream of settings changes
  Stream<PlatformContributionSettings> onSettingsChanged();
}
