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

class FamilyOverviewUpdatedState extends FamilyOverviewState {
  const FamilyOverviewUpdatedState({
    required this.profiles,
    required this.displayAllowanceInfo,
  });

  final List<Profile> profiles;
  final bool displayAllowanceInfo;

  List<Profile> get children {
    return profiles.where((p) => p.type == 'Child').toList();
  }

  List<Profile> get adults {
    return profiles.where((p) => p.type == 'Parent').toList();
  }

  bool get hasChildren {
    return children.isNotEmpty;
  }

  bool get isAdultSingle {
    return adults.length == 1;
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
