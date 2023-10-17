enum Pages {
  splash,
  home,
  welcome,
  selectGivingWay,
  give,
  giveSucess,
  giveByList,
  chooseCategoryList,
  chooseCategoryEnterAmount,
  giveByQrCode,
  giveByLocation,
  giveByBeacon,
  signSepaMandate,
  signBacsMandate,
  giftAid,
  personalInfo,
  sepaMandateExplanation,
  bacsMandateExplanation,
  creditCardDetail,
  registration,
  overview,
  personalInfoEdit,
  giveVPC,
  unregister,
  createChild,
  personalSummary,
  addExternalDonation,
  recurringDonations,
  childrenOverview
}

extension AppPageExtension on Pages {
  String get path {
    switch (this) {
      case Pages.splash:
        return '/';
      case Pages.home:
        return '/home';
      case Pages.welcome:
        return '/welcome';
      case Pages.selectGivingWay:
        return 'select-giving-way';
      case Pages.give:
        return 'give';
      case Pages.giveSucess:
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
      case Pages.creditCardDetail:
        return 'credit-card-detail';
      case Pages.registration:
        return 'registration';
      case Pages.giveByList:
        return 'give-by-list';
      case Pages.giveByQrCode:
        return 'give-by-qr-code';
      case Pages.giveByLocation:
        return 'give-by-location';
      case Pages.giveByBeacon:
        return 'give-by-beacon';
      case Pages.overview:
        return 'overview';
      case Pages.personalInfoEdit:
        return 'personal-info-edit';
      case Pages.giveVPC:
        return 'give-vpc';
      case Pages.unregister:
        return 'unregister';
      case Pages.createChild:
        return 'create-child';
      case Pages.personalSummary:
        return 'personal-summary';
      case Pages.addExternalDonation:
        return 'add-external-donation';
      case Pages.recurringDonations:
        return 'recurring-donations';
      case Pages.childrenOverview:
        return 'children-overview';
      case Pages.chooseCategoryList:
        return 'choose-category-list';
      case Pages.chooseCategoryEnterAmount:
        return 'choose-category-enter-amount';
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
      case Pages.giveSucess:
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
      case Pages.creditCardDetail:
        return 'CREDIT-CARD-DETAIL';
      case Pages.registration:
        return 'REGISTRATION';
      case Pages.giveByList:
        return 'GIVE-BY-LIST';
      case Pages.giveByQrCode:
        return 'GIVE-BY-QR-CODE';
      case Pages.giveByLocation:
        return 'GIVE-BY-LOCATION';
      case Pages.giveByBeacon:
        return 'GIVE-BY-BEACON';
      case Pages.overview:
        return 'OVERVIEW';
      case Pages.personalInfoEdit:
        return 'PERSONAL-INFO-EDIT';
      case Pages.giveVPC:
        return 'GIVE-VPC';
      case Pages.unregister:
        return 'UNREGISTER';
      case Pages.createChild:
        return 'CREATE-CHILD';
      case Pages.personalSummary:
        return 'PERSONAL-SUMMARY';
      case Pages.addExternalDonation:
        return 'ADD-EXTERNAL-DONATION';
      case Pages.recurringDonations:
        return 'RECURRING-DONATIONS';
      case Pages.childrenOverview:
        return 'CHILDREN-OVERVIEW';
      case Pages.chooseCategoryList:
        return 'CHOOSE-CATEGORY-LIST';
      case Pages.chooseCategoryEnterAmount:
        return 'CHOOSE-CATEGORY-ENTER-AMOUNT';
    }
  }
}
