part of 'profiles_cubit.dart';

abstract class ProfilesState extends Equatable {
  const ProfilesState({
    required this.profiles,
    required this.activeProfileIndex,
    this.cachedMembers = const [],
  });
  final List<Member> cachedMembers;

  static const int _loggedInUserSelected = 0;

  final List<Profile> profiles;
  final int activeProfileIndex;

  @override
  List<Object> get props => [profiles, activeProfileIndex];

  bool get isProfileSelected {
    return profiles.isNotEmpty;
  }

  Profile get activeProfile {
    if (profiles.isEmpty) {
      return Profile.empty();
    } else {
      return profiles[activeProfileIndex];
    }
  }

  List<Profile> get children {
    return profiles.where((p) => p.type.contains('Child')).toList();
  }

  List<Profile> get parents {
    return profiles.where((p) => p.type.contains('Parent')).toList();
  }

  bool get isOnlyChild {
    if (profiles.isEmpty) return false;
    return profiles.where((element) => element.type.contains('Child')).length ==
        1;
  }
}

class ProfilesInitialState extends ProfilesState {
  const ProfilesInitialState({
    super.profiles = const [],
    super.activeProfileIndex = ProfilesState._loggedInUserSelected,
  });
}

class ProfilesLoadingState extends ProfilesState {
  /// This is the state that is emitted when the profiles are being fetched for the first time.
  const ProfilesLoadingState({
    super.profiles = const [],
    super.activeProfileIndex = ProfilesState._loggedInUserSelected,
  });
}

class ProfilesUpdatedState extends ProfilesState {
  /// This is the state that is emitted when the profiles are updated
  const ProfilesUpdatedState({
    required super.profiles,
    required super.activeProfileIndex,
    super.cachedMembers,
  });
}

class ProfilesNoChurchSelected extends ProfilesState {
  /// This is the state that is emitted when the user has not selected a church
  const ProfilesNoChurchSelected({
    required super.profiles,
    required super.activeProfileIndex,
    super.cachedMembers,
  });
}

class ProfilesNotSetupState extends ProfilesState {
  /// This is the state that is emitted when profiles have not yet been setup
  const ProfilesNotSetupState({
    required super.profiles,
    required super.activeProfileIndex,
    super.cachedMembers,
  });
}

class ProfilesNeedsRegistration extends ProfilesState {
  /// This is the state that is emitted when the user still needs to register
  const ProfilesNeedsRegistration({
    required super.profiles,
    required super.activeProfileIndex,
    this.hasFamily = false,
  });

  final bool hasFamily;
}

class ProfilesInvitedToGroup extends ProfilesState {
  /// This is the state that is emitted when the user still needs to register
  const ProfilesInvitedToGroup({
    required super.profiles,
    required super.activeProfileIndex,
    required this.impactGroup,
  });

  final ImpactGroup impactGroup;

  @override
  List<Object> get props => [profiles, activeProfileIndex, impactGroup];
}

class ProfilesExternalErrorState extends ProfilesState {
  const ProfilesExternalErrorState({
    required super.profiles,
    required super.activeProfileIndex,
    this.errorMessage = '',
  });

  final String errorMessage;

  @override
  List<Object> get props => [profiles, activeProfileIndex, errorMessage];
}

class ProfilesCountdownState extends ProfilesState {
  const ProfilesCountdownState({
    required super.profiles,
    required super.activeProfileIndex,
    required this.amount,
  });

  final double amount;

  @override
  List<Object> get props => [profiles, activeProfileIndex, amount];
}
