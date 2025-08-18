part of 'profiles_cubit.dart';

abstract class ProfilesState extends Equatable {
  const ProfilesState({
    required this.profiles,
    required this.activeProfileIndex,
    required this.showBarcodeHunt,
  });

  static const int _loggedInUserSelected = 0;

  final List<Profile> profiles;
  final int activeProfileIndex;
  final bool showBarcodeHunt;

  @override
  List<Object> get props => [profiles, activeProfileIndex, showBarcodeHunt];

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
    return profiles.where((p) => p.type == tabsOptions.first).toList();
  }

  List<Profile> get parents {
    return profiles.where((p) => p.type == tabsOptions.last).toList();
  }

  bool get isOnlyChild {
    if (profiles.isEmpty) return false;
    return profiles.where((element) => element.type == tabsOptions.first).length ==
        1;
  }
}

class ProfilesInitialState extends ProfilesState {
  const ProfilesInitialState({
    super.profiles = const [],
    super.activeProfileIndex = ProfilesState._loggedInUserSelected,
    super.showBarcodeHunt = false,
  });
}

class ProfilesLoadingState extends ProfilesState {
  /// This is the state that is emitted when the profiles are being fetched for the first time.
  const ProfilesLoadingState({
    super.profiles = const [],
    super.activeProfileIndex = ProfilesState._loggedInUserSelected,
    super.showBarcodeHunt = false,
  });
}

class ProfilesUpdatedState extends ProfilesState {
  /// This is the state that is emitted when the profiles are updated
  const ProfilesUpdatedState({
    required super.profiles,
    required super.activeProfileIndex,
    required super.showBarcodeHunt,
  });
}

class ProfilesExternalErrorState extends ProfilesState {
  const ProfilesExternalErrorState({
    required super.profiles,
    required super.activeProfileIndex,
    required super.showBarcodeHunt,
    this.errorMessage = '',
  });

  final String errorMessage;

  @override
  List<Object> get props => [profiles, activeProfileIndex, showBarcodeHunt, errorMessage];
}

class ProfilesCountdownState extends ProfilesState {
  const ProfilesCountdownState({
    required super.profiles,
    required super.activeProfileIndex,
    required super.showBarcodeHunt,
    required this.amount,
  });

  final double amount;

  @override
  List<Object> get props => [profiles, activeProfileIndex, showBarcodeHunt, amount];
}
