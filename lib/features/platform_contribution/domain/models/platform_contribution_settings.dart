import 'package:equatable/equatable.dart';
import 'platform_contribution_organization.dart';

/// Represents the platform contribution settings
class PlatformContributionSettings extends Equatable {
  const PlatformContributionSettings({
    required this.organizations,
    required this.hasChanges,
  });

  final List<PlatformContributionOrganization> organizations;
  final bool hasChanges;

  PlatformContributionSettings copyWith({
    List<PlatformContributionOrganization>? organizations,
    bool? hasChanges,
  }) {
    return PlatformContributionSettings(
      organizations: organizations ?? this.organizations,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  @override
  List<Object?> get props => [organizations, hasChanges];
}
