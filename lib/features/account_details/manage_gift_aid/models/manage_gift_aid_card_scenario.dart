/// Which impact card layout to show (ENG-25 scenarios A/B vs C).
enum ManageGiftAidCardScenario {
  /// Teal accordion: Gift Aid active, or inactive but had Gift-Aided donations
  /// this tax year.
  tealImpact,

  /// Orange accordion: inactive and no Gift-Aided donations this TY.
  orangeOpportunity,
}
