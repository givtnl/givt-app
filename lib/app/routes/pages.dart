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
  giveByQrCode(path: 'give-by-qr-code', name: 'GIVE-BY-QR-CODE'),
  giveByLocation(path: 'give-by-location', name: 'GIVE-BY-LOCATION'),
  giveByBeacon(path: 'give-by-beacon', name: 'GIVE-BY-BEACON'),
  signSepaMandate(path: 'sign-sepa-mandate', name: 'SIGN-SEPA-MANDATE'),
  signBacsMandate(path: 'sign-bacs-mandate', name: 'SIGN-BACS-MANDATE'),
  giftAid(path: 'gift-aid', name: 'GIFT-AID'),
  personalInfo(path: 'personal-info', name: 'PERSONAL-INFO'),
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
  registrationSuccessUs(
    path: 'registration-success-us',
    name: 'REGISTRATION-SUCCESS-US',
  ),
  overview(path: 'overview', name: 'OVERVIEW'),
  personalInfoEdit(path: 'personal-info-edit', name: 'PERSONAL-INFO-EDIT'),
  giveVPC(path: 'give-vpc', name: 'GIVE-VPC'),
  unregister(path: 'unregister', name: 'UNREGISTER'),
  createChild(path: 'create-child', name: 'CREATE-CHILD'),
  personalSummary(path: 'personal-summary', name: 'PERSONAL-SUMMARY'),
  yearlyOverview(path: 'yearly-overview', name: 'YEARLY-OVERVIEW'),
  addExternalDonation(
    path: 'add-external-donation',
    name: 'ADD-EXTERNAL-DONATION',
  ),
  recurringDonations(path: 'recurring-donations', name: 'RECURRING-DONATIONS'),
  childrenOverview(path: 'children-overview', name: 'CHILDREN-OVERVIEW'),
  childDetails(path: 'child-details', name: 'CHILD-DETAILS'),
  editChild(path: 'edit-child', name: 'EDIT-CHILD'),
  creditCardDetails(path: 'credit-card-details', name: 'CREDIT-CARD-DETAILS'),
  editCreditCardDetails(
    path: 'edit-credit-card-details',
    name: 'EDIT-CREDIT-CARD-DETAILS',
  ),
  addMember(path: 'add-member', name: 'ADD-MEMBER'),
  avatarSelection(path: 'avatar-selection', name: 'AVATAR-SELECTION'),
  cachedChildrenOverview(
    path: 'cached-children-overview',
    name: 'CACHED-CHILDREN-OVERVIEW',
  ),
  createFamilyGoal(path: 'create-family-goal', name: 'CREATE-FAMILY-GOAL'),
  joinImpactGroupSuccess(
    path: 'join-impact-group-success',
    name: 'JOIN-IMPACT-GROUP-SUCCESS',
  ),
  permitBiometric(path: 'permit-biometric', name: 'PERMIT-BIOMETRIC'),
  ;

  const Pages({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}
