import 'package:equatable/equatable.dart';

/// Represents a platform contribution organization
class PlatformContributionOrganization extends Equatable {
  const PlatformContributionOrganization({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.isEnabled,
    required this.contributionLevel,
  });

  final String id;
  final String name;
  final String iconPath;
  final bool isEnabled;
  final PlatformContributionLevel contributionLevel;

  PlatformContributionOrganization copyWith({
    String? id,
    String? name,
    String? iconPath,
    bool? isEnabled,
    PlatformContributionLevel? contributionLevel,
  }) {
    return PlatformContributionOrganization(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isEnabled: isEnabled ?? this.isEnabled,
      contributionLevel: contributionLevel ?? this.contributionLevel,
    );
  }

  @override
  List<Object?> get props => [id, name, iconPath, isEnabled, contributionLevel];
}

/// Represents the contribution level for an organization
enum PlatformContributionLevel {
  mostPopular,
  extraGenerous,
}

extension PlatformContributionLevelExtension on PlatformContributionLevel {
  String get displayName {
    switch (this) {
      case PlatformContributionLevel.mostPopular:
        return 'Most popular';
      case PlatformContributionLevel.extraGenerous:
        return 'Extra generous';
    }
  }
}
