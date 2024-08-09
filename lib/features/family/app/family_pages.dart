enum FamilyPages {
  profileSelection(path: '/profile-selection', name: 'PROFILE_SELECTION'),
  kidsAvatarSelection(
      path: 'kids-avatar-selection', name: 'KIDS-AVATAR-SELECTION'),
  parentAvatarSelection(
      path: 'parent-avatar-selection', name: 'PARENT-AVATAR-SELECTION'),
  wallet(path: 'wallet', name: 'WALLET'),
  parentHome(path: 'parent-home', name: 'PARENT-HOME'),
  camera(path: 'camera', name: 'CAMERA'),
  success(path: 'success', name: 'SUCCESS'),
  unregisterUS(path: 'unregister-us', name: 'UNREGISTER-US'),
  familyChooseAmountSlider(
    path: 'family-choose-amount-slider',
    name: 'FAMILY_CHOOSE_AMOUNT_SLIDER',
  ),
  familyPersonalInfoEdit(
    path: 'family-personal-info-edit',
    name: 'FAMILY-PERSONAL-INFO-EDIT',
  ),
  registrationUS(path: 'registration-us', name: 'REGISTRATION-US'),
  registrationSuccessUs(
    path: 'registration-success-us',
    name: 'REGISTRATION-SUCCESS-US',
  ),
  permitUSBiometric(
      path: 'permit-biometric-us', name: 'US-PERMIT-BIOMETRIC-US'),
  giveByListFamily(path: 'give-by-list-family', name: 'GIVE-BY-LIST-FAMILY'),
  creditCardDetails(path: 'credit-card-details', name: 'CREDIT-CARD-DETAILS'),
  test(path: 'test', name: 'TEST'),
  scanNFC(path: 'scan-nfc', name: 'SCAN_NFC'),
  history(path: 'history', name: 'HISTORY'),
  childrenOverview(path: 'children-overview', name: 'CHILDREN-OVERVIEW'),
  addMember(path: 'add-member', name: 'ADD-MEMBER'),
  childDetails(path: 'child-details', name: 'CHILD-DETAILS'),
  editChild(path: 'edit-child', name: 'EDIT-CHILD'),
  createChild(path: 'create-child', name: 'CREATE-CHILD'),
  createFamilyGoal(path: 'create-family-goal', name: 'CREATE-FAMILY-GOAL'),
  cachedChildrenOverview(
    path: 'cached-children-overview',
    name: 'CACHED-CHILDREN-OVERVIEW',
  ),

  //recommendation flow
  recommendationStart(
      path: 'recommendation-start', name: 'RECOMMENDATION_START'),
  locationSelection(path: 'location-selection', name: 'LOCATION_SELECTION'),
  interestsSelection(path: 'interests-selection', name: 'INTERESTS_SELECTION'),
  recommendedOrganisations(path: 'organisations', name: 'ORGANISATIONS'),

  //coin flow
  searchForCoin(path: 'search-for-coin', name: 'SEARCH_FOR_COIN'),
  outAppCoinFlow(path: 'out-app-coin-flow', name: 'OUT_APP_COIN_FLOW'),
  successCoin(path: 'success-coin', name: 'SUCCESS_COIN'),
  redirectPopPage(path: 'redirect-pop-page', name: 'REDIRECT_POP_PAGE'),

  //exhibition flow
  voucherCode(path: 'voucher-code', name: 'VOUCHER_CODE'),
  exhibitionOrganisations(
      path: 'exhibition-organisations', name: 'EXHIBITION_ORGANISATIONS'),
  successExhibitionCoin(
      path: 'success-exhibition-coin', name: 'SUCCESS_EXHIBITION_COIN'),

  //design alignment
  designAlignment(path: 'design-alignment', name: 'DESIGN_ALIGNMENT'),
  chooseAmountSliderGoal(
      path: 'choose-amount-slider-goal', name: 'CHOOSE_AMOUNT_SLIDER_GOAL'),

  //generosity challenge
  generosityChallengeRedirect(
    path: '/generosity-challenge-redirect',
    name: 'GENEROSITY-CHALLENGE-REDIRECT',
  ),
  generosityChallenge(
    path: '/generosity-challenge',
    name: 'GENEROSITY-CHALLENGE',
  ),
  generosityChallengeChat(
    path: 'generosity-challenge-chat',
    name: 'GENEROSITY-CHALLENGE-CHAT',
  ),
  generosityChallengeIntroduction(
    path: 'generosity-challenge-introduction',
    name: 'GENEROSITY-CHALLENGE-INTRODUCTION',
  ),
  selectValues(
    path: 'select-values',
    name: 'SELECT-VALUES',
  ),
  displayValues(
    path: 'display-values',
    name: 'DISPLAY-VALUES',
  ),
  displayValuesOrganisations(
    path: 'display-values-organisations',
    name: 'DISPLAY-VALUES-ORGANISATIONS',
  ),
  chooseAmountSlider(
    path: 'choose-amount-slider',
    name: 'CHOOSE-AMOUNT-SLIDER',
  ),
  allowanceFlow(
    path: 'allowance-flow',
    name: 'ALLOWANCE-FLOW',
  ),
  day4Timer(
    path: 'day-4-timer',
    name: 'DAY-4-TIMER',
  ),

  //school event mode
  familyNameLogin(path: 'family-name-login', name: 'FAMILY_NAME_LOGIN'),
  schoolEventInfo(path: 'school-event-info', name: 'SCHOOL_EVENT_INFO'),
  schoolEventOrganisations(
      path: 'school-event-organisations', name: 'SCHOOL_EVENT_ORGANISATIONS'),
  impactGroupDetails(
    path: 'kids-impact-group-details',
    name: 'KIDS_IMPACT_GROUP_DETAILS',
  ),
  ;

  final String path;
  final String name;

  const FamilyPages({
    required this.path,
    required this.name,
  });
}
