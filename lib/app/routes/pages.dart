enum Pages {
  splash(path: '/', name: 'SPLASH'),
  home(path: '/home', name: 'HOME'),
  loading(path: '/loading', name: 'LOADING'),
  welcome(path: '/welcome', name: 'WELCOME'),
  selectGivingWay(path: 'select-giving-way', name: 'GIVING-WAY'),
  give(path: 'give', name: 'GIVE'),
  giveSucess(path: 'give-offline', name: 'GIVE-OFFLINE'),
  giveByList(path: 'give-by-list', name: 'GIVE-BY-LIST'),
  chooseCategoryList(
    path: 'choose-category-list',
    name: 'CHOOSE-CATEGORY-LIST',
  ),
  chooseCategoryEnterAmount(
    path: 'choose-category-enter-amount',
    name: 'CHOOSE-CATEGORY-ENTER-AMOUNT',
  ),
  personalInfo(path: 'personal-info', name: 'PERSONAL-INFO'),
  giveByQrCode(path: 'give-by-qr-code', name: 'GIVE-BY-QR-CODE'),
  giveByLocation(path: 'give-by-location', name: 'GIVE-BY-LOCATION'),
  giveByBeacon(path: 'give-by-beacon', name: 'GIVE-BY-BEACON'),
  signSepaMandate(path: 'sign-sepa-mandate', name: 'SIGN-SEPA-MANDATE'),
  signBacsMandate(path: 'sign-bacs-mandate', name: 'SIGN-BACS-MANDATE'),
  giftAid(path: 'gift-aid', name: 'GIFT-AID'),
  sepaMandateExplanation(
    path: 'sepa-mandate-explanation',
    name: 'SEPA-MANDATE-EXPLANATION',
  ),
  bacsMandateExplanation(
    path: 'bacs-mandate-explanation',
    name: 'BACS-MANDATE-EXPLANATION',
  ),
  registration(path: 'registration', name: 'REGISTRATION'),
  registrationSuccess(
    path: 'registration-success',
    name: 'REGISTRATION-SUCCESS',
  ),
  overview(path: 'overview', name: 'OVERVIEW'),
  personalInfoEdit(path: 'personal-info-edit', name: 'PERSONAL-INFO-EDIT'),
  giveVPC(path: 'give-vpc', name: 'GIVE-VPC'),
  unregister(path: 'unregister', name: 'UNREGISTER'),
  personalSummary(path: 'personal-summary', name: 'PERSONAL-SUMMARY'),
  yearlyOverview(path: 'yearly-overview', name: 'YEARLY-OVERVIEW'),
  addExternalDonation(
    path: 'add-external-donation',
    name: 'ADD-EXTERNAL-DONATION',
  ),
  recurringDonations(path: 'recurring-donations', name: 'RECURRING-DONATIONS'),
  editCreditCardDetails(
    path: 'edit-credit-card-details',
    name: 'EDIT-CREDIT-CARD-DETAILS',
  ),
  permitBiometric(path: 'permit-biometric', name: 'PERMIT-BIOMETRIC'),

  impactGroupDetails(
    path: '/impact-group-details',
    name: 'IMPACT-GROUP-DETAILS',
  ),
  ;

  const Pages({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}
