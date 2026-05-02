import 'package:equatable/equatable.dart';
import 'package:givt_app/features/account_details/manage_gift_aid/models/manage_gift_aid_card_scenario.dart';

class ManageGiftAidUIModel extends Equatable {
  const ManageGiftAidUIModel({
    required this.taxYearIndex,
    required this.displayYear,
    required this.scenario,
    required this.isGiftAidEnabled,
    required this.totalGiven,
    required this.extraOrPotentialAmount,
    required this.totalImpactAmount,
    required this.impactAccordionExpanded,
  });

  final int taxYearIndex;
  final int displayYear;
  final ManageGiftAidCardScenario scenario;
  final bool isGiftAidEnabled;
  final double totalGiven;
  final double extraOrPotentialAmount;
  final double totalImpactAmount;
  final bool impactAccordionExpanded;

  ManageGiftAidUIModel copyWith({
    int? taxYearIndex,
    int? displayYear,
    ManageGiftAidCardScenario? scenario,
    bool? isGiftAidEnabled,
    double? totalGiven,
    double? extraOrPotentialAmount,
    double? totalImpactAmount,
    bool? impactAccordionExpanded,
  }) {
    return ManageGiftAidUIModel(
      taxYearIndex: taxYearIndex ?? this.taxYearIndex,
      displayYear: displayYear ?? this.displayYear,
      scenario: scenario ?? this.scenario,
      isGiftAidEnabled: isGiftAidEnabled ?? this.isGiftAidEnabled,
      totalGiven: totalGiven ?? this.totalGiven,
      extraOrPotentialAmount:
          extraOrPotentialAmount ?? this.extraOrPotentialAmount,
      totalImpactAmount: totalImpactAmount ?? this.totalImpactAmount,
      impactAccordionExpanded:
          impactAccordionExpanded ?? this.impactAccordionExpanded,
    );
  }

  @override
  List<Object?> get props => [
        taxYearIndex,
        displayYear,
        scenario,
        isGiftAidEnabled,
        totalGiven,
        extraOrPotentialAmount,
        totalImpactAmount,
        impactAccordionExpanded,
      ];
}
