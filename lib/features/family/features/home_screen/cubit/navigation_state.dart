part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  const NavigationState({
    this.activeDestination = NavigationDestinationData.home,
  });

  final NavigationDestinationData activeDestination;

  NavigationState copyWith({
    NavigationDestinationData? activeDestination,
  }) {
    return NavigationState(
      activeDestination: activeDestination ?? this.activeDestination,
    );
  }

  @override
  List<Object> get props => [activeDestination];
}

enum NavigationDestinationData {
  home(
    iconPath: 'assets/family/images/duotone_house.svg',
    label: 'Home',
    appBarTitle: '',
  ),
  groups(
    iconPath: 'assets/family/images/duotone_users.svg',
    label: 'Groups',
    appBarTitle: 'Groups',
  ),
  myGivts(
    iconPath: 'assets/family/images/duotone_staggered_bars.svg',
    label: 'My givts',
    appBarTitle: 'My givts',
  ),
  ;

  final String iconPath;
  final String label;
  final String appBarTitle;

  const NavigationDestinationData({
    required this.iconPath,
    required this.label,
    required this.appBarTitle,
  });
}
