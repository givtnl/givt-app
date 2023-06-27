enum Pages {
  splash,
  home,
  welcome,
  selectGivingWay,
  give,
  giveOffline,
}

extension AppPageExtension on Pages {
  String get path {
    switch (this) {
      case Pages.splash:
        return '/';
      case Pages.home:
        return 'home';
      case Pages.welcome:
        return 'welcome';
      case Pages.selectGivingWay:
        return 'select_giving_way';
      case Pages.give:
        return 'give';
      case Pages.giveOffline:
        return 'give_offline';
    }
  }

  String get name {
    switch (this) {
      case Pages.home:
        return 'HOME';
      case Pages.splash:
        return 'SPLASH';
      case Pages.welcome:
        return 'WELCOME';
      case Pages.selectGivingWay:
        return 'GIVING_WAY';
      case Pages.give:
        return 'GIVE';
      case Pages.giveOffline:
        return 'GIVE_OFFLINE';
    }
  }
}
