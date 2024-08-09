part of 'family_overview_cubit.dart';

sealed class FamilyOverviewState extends Equatable {
  const FamilyOverviewState();

  @override
  List<Object> get props => [];
}

class FamilyOverviewInitialState extends FamilyOverviewState {
  const FamilyOverviewInitialState();
}

class FamilyOverviewLoadingState extends FamilyOverviewState {
  const FamilyOverviewLoadingState();
}

class FamilyOverviewAllowanceWarningState extends FamilyOverviewState {
  const FamilyOverviewAllowanceWarningState();
}

class FamilyOverviewUpdatedState extends FamilyOverviewState {
  const FamilyOverviewUpdatedState({
    required this.profiles,
    required this.displayAllowanceInfo,
  });

  final List<LegacyProfile> profiles;
  final bool displayAllowanceInfo;

  List<LegacyProfile> get children {
    return profiles.where((p) => p.type == ProfileType.Child).toList();
  }

  List<LegacyProfile> get adults {
    return profiles.where((p) => p.type == ProfileType.Parent).toList();
  }

  bool get hasChildren {
    return children.isNotEmpty;
  }

  bool get isAdultSingle {
    return adults.length == 1;
  }

  // The Givt user profile is first in the list
  List<LegacyProfile> sortedAdults(String givtAccountID) {
    return adults
      ..sort((a, b) {
        final compareNames = a.firstName.compareTo(b.id);
        return a.id == givtAccountID
            ? -1
            : b.id == givtAccountID
                ? 1
                : compareNames;
      });
  }

  @override
  List<Object> get props => [profiles, displayAllowanceInfo];
}

class FamilyOverviewErrorState extends FamilyOverviewState {
  const FamilyOverviewErrorState({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
