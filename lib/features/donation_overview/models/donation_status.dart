import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

enum DonationStatusType {
  completed,
  created,
  inProcess,
  refused,
  cancelled,
}

class DonationStatus extends Equatable {
  const DonationStatus({
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.textColor,
    required this.isAccessibleForColorblind,
  });

  final DonationStatusType type;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color textColor;
  final bool isAccessibleForColorblind;

  static const Map<DonationStatusType, DonationStatus> statuses = {

    DonationStatusType.completed: DonationStatus(
      type: DonationStatusType.completed,
      icon: FontAwesomeIcons.check,
      iconColor: FamilyAppTheme.primary30,
      backgroundColor: FamilyAppTheme.primary95,
      textColor: FamilyAppTheme.primary50,
      isAccessibleForColorblind: true,
    ),
    DonationStatusType.created: DonationStatus(
      type: DonationStatusType.created,
      icon: FontAwesomeIcons.hourglassHalf,
      iconColor: FamilyAppTheme.secondary40,
      backgroundColor: FamilyAppTheme.secondary95,
      textColor: FamilyAppTheme.secondary40,
      isAccessibleForColorblind: true,
    ),
    DonationStatusType.inProcess: DonationStatus(
      type: DonationStatusType.inProcess,
      icon: FontAwesomeIcons.hourglassHalf,
      iconColor: FamilyAppTheme.secondary40,
      backgroundColor: FamilyAppTheme.secondary95,
      textColor: FamilyAppTheme.secondary40,
      isAccessibleForColorblind: true,
    ),
    DonationStatusType.refused: DonationStatus(
      type: DonationStatusType.refused,
      icon: FontAwesomeIcons.exclamation,
      iconColor: FamilyAppTheme.highlight30,
      backgroundColor: FamilyAppTheme.highlight95,
      textColor: FamilyAppTheme.highlight50,
      isAccessibleForColorblind: true,
    ),
    DonationStatusType.cancelled: DonationStatus(
      type: DonationStatusType.cancelled,
      icon: FontAwesomeIcons.xmark,
      iconColor: FamilyAppTheme.error30,
      backgroundColor: FamilyAppTheme.error90,
      textColor: FamilyAppTheme.error50,
      isAccessibleForColorblind: true,
    ),
  };

  static DonationStatus fromLegacyStatus(int legacyStatus) {
    switch (legacyStatus) {
      case 1:
        return statuses[DonationStatusType.created]!;
      case 2:
        return statuses[DonationStatusType.inProcess]!;
      case 3:
        return statuses[DonationStatusType.completed]!;
      case 4:
        return statuses[DonationStatusType.refused]!;
      case 5:
        return statuses[DonationStatusType.cancelled]!;
      default:
        return statuses[DonationStatusType.completed]!;
    }
  }

  @override
  List<Object?> get props => [
    type,
    icon,
    iconColor,
    backgroundColor,
    textColor,
    isAccessibleForColorblind,
  ];
}
