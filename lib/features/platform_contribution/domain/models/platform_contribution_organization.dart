import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';

/// Represents a platform contribution organization
class PlatformContributionOrganization extends Equatable {
  const PlatformContributionOrganization({
    required this.id,
    required this.name,
    required this.type,
    required this.isEnabled,
    required this.contributionLevel,
  });

  final String id;
  final String name;
  final CollectGroupType type;
  final bool isEnabled;
  final PlatformContributionLevel contributionLevel;

  PlatformContributionOrganization copyWith({
    String? id,
    String? name,
    CollectGroupType? type,
    bool? isEnabled,
    PlatformContributionLevel? contributionLevel,
  }) {
    return PlatformContributionOrganization(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      contributionLevel: contributionLevel ?? this.contributionLevel,
    );
  }

  @override
  List<Object?> get props => [id, name, type, isEnabled, contributionLevel];
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
