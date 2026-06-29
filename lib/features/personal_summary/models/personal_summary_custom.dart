sealed class PersonalSummaryCustom {
  const PersonalSummaryCustom();
}

final class NavigateToForYouList extends PersonalSummaryCustom {
  const NavigateToForYouList();
}

final class NavigateToExternalDonationCreate extends PersonalSummaryCustom {
  const NavigateToExternalDonationCreate();
}

final class ShowAddDonationSheet extends PersonalSummaryCustom {
  const ShowAddDonationSheet();
}

final class NavigateToGivingGoalSetup extends PersonalSummaryCustom {
  const NavigateToGivingGoalSetup();
}

final class PersonalSummaryGoalSaved extends PersonalSummaryCustom {
  const PersonalSummaryGoalSaved();
}

final class PersonalSummaryGoalMutationFailed extends PersonalSummaryCustom {
  const PersonalSummaryGoalMutationFailed({
    this.isNoInternet = false,
    this.message,
  });

  final bool isNoInternet;
  final String? message;
}
