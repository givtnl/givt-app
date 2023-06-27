enum Pages {
  splash,
  home,
  welcome,
  selectGivingWay,
  give,
  giveOffline,
  signSepaMandate,
  signBacsMandate,
  giftAid,
  personalInfo,
  sepaMandateExplanation,
  bacsMandateExplanation,
  registration,
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
        return 'select-giving-way';
      case Pages.give:
        return 'give';
      case Pages.giveOffline:
        return 'give-offline';
      case Pages.signSepaMandate:
        return 'sign-sepa-mandate';
      case Pages.signBacsMandate:
        return 'sign-bacs-mandate';
      case Pages.giftAid:
        return 'gift-aid';
      case Pages.personalInfo:
        return 'personal-info';
      case Pages.sepaMandateExplanation:
        return 'sepa-mandate-explanation';
      case Pages.bacsMandateExplanation:
        return 'bacs-mandate-explanation';
      case Pages.registration:
        return 'registration';
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
        return 'GIVING-WAY';
      case Pages.give:
        return 'GIVE';
      case Pages.giveOffline:
        return 'GIVE-OFFLINE';
      case Pages.signSepaMandate:
        return 'SIGN-SEPA-MANDATE';
      case Pages.signBacsMandate:
        return 'SIGN-BACS-MANDATE';
      case Pages.giftAid:
        return 'GIFT-AID';
      case Pages.personalInfo:
        return 'PERSONAL-INFO';
      case Pages.sepaMandateExplanation:
        return 'SEPA-MANDATE-EXPLANATION';
      case Pages.bacsMandateExplanation:
        return 'BACS-MANDATE-EXPLANATION';
      case Pages.registration:
        return 'REGISTRATION';
    }
  }
}
