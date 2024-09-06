enum AmplitudeEvents {
  letsGo('lets_go'),
  welcomeContinueClicked('welcome_continue_clicked'),
  loginClicked('login_clicked'),
  emailSignupContinueClicked('email_signup_continue_clicked'),
  familyClicked('family_clicked'),
  seeMyFamilyClicked('see_my_family_clicked'),
  addChildProfile('add_child_profile'),
  addParentProfile('add_parent_profile'),
  addMemberClicked('add_member_clicked'),
  addMemberDoneClicked('add_member_done_clicked'),
  numberOfMembersSelected('number_of_members_selected'),
  memberCreatedSuccesfully('member_created_succesfully'),
  addMemberContinueClicked('add_member_continue_clicked'),
  failedToCreateMember('failed_to_create_member'),
  failedToGetVpc('failed_to_get_vpc'),
  failedTopUpNoFunds('failed_top_up_no_funds'),
  allowanceNotSuccessful('allowance_not_successful'),
  backClicked('back_clicked'),
  cancelClicked('cancel_clicked'),
  okClicked('ok_clicked'),
  continueClicked('continue_clicked'),
  readyClicked('ready_clicked'),
  retryClicked('retry_clicked'),
  createChildProfileClicked('create_child_profile_clicked'),
  directNoticeClicked('direct_notice_clicked'),
  enterCardDetailsClicked('enter_card_details_clicked'),
  infoGivingAllowanceClicked('info_giving_allowance_clicked'),
  infoGivingAllowanceDismissed('info_giving_allowance_dismissed'),
  setUpChildProfileClicked('set_up_child_profile_clicked'),
  vpcAccepted('vpc_accepted'),
  vpcSuccess('vpc_successful'),
  vpcCancelled('vpc_cancelled'),
  childDetailsEditAppBarClicked('child_details_edit_app_bar_clicked'),
  childDetailsEditCardClicked(
    'child_details_edit_card_clicked',
  ),
  childTopUpCardClicked('child_top_up_card_clicked'),
  childTopUpSubmitted('child_top_up_submitted'),
  childEditSaveClicked('child_edit_save_clicked'),
  childEditMonthlyAllowanceSaveClicked(
    'child_edit_monthly_allowance_save_clicked',
  ),

  // Topup flow
  topupFailed('topup_failed'),
  topUpConfirmClicked('top_up_confirm_clicked'),

  // Cancel Recurring Giving allowance flow
  cancelRGA('cancel_reccuring_giving_allowance'),
  failedToCancelRGA('failed_to_cancel_allowance'),
  cancelRGAYesClicked('cancel_rga_yes_clicked'),
  cancelRGANoClicked('cancel_rga_no_clicked'),

  // Edit Recurring Giving allowance flow
  editRGAConfirmClicked('edit_rga_confirm_clicked'),

  childEditCancelClicked('child_edit_cancel_clicked'),
  childProfileClicked('child_profile_clicked'),
  adultProfileTileClicked('adult_profile_tile_clicked'),
  pendingDonationClicked('pending_donation_clicked'),
  pendingDonationApproved('pending_donation_approved'),
  pendingDonationDeclined('pending_donation_declined'),
  pendingDonationCloseClicked('pending_donation_close_clicked'),
  personalSummaryClicked('personal_summary_clicked'),
  personalSummaryYearClicked('personal_summary_year_clicked'),
  personalSummaryYearLoaded('personal_summary_year_loaded'),
  downloadAnnualOverviewClicked('download_annual_overview_clicked'),
  annualOverviewReceiveViaMailClicked(
    'annual_overview_receive_via_mail_clicked',
  ),
  setGivingGoalClicked('set_giving_goal_clicked'),
  editGivingGoalClicked('edit_giving_goal_clicked'),
  givingGoalSaved('giving_goal_saved'),
  removeGivingGoalClicked('remove_giving_goal_clicked'),
  recurringDonationsClicked('recurring_donations_clicked'),
  editAvatarPictureClicked('edit_avatar_picture_clicked'),
  avatarSelected('avatar_selected'),
  avatarSaved('avatar_saved'),
  cacheMembersDueToNoFunds('cache_members_due_to_no_funds'),
  changePaymentMethodForFailedVPCClicked(
    'change_payment_method_for_failed_vpc_clicked',
  ),
  vpcReadyClicked('vpc_ready_clicked'),
  tryAgainForFailedVPCClicked('try_again_for_failed_vpc_clicked'),
  failedToCreateMembersFromCache('failed_to_create_members_from_cache'),
  familyGoalCreateClicked('family_goal_create_clicked'),
  familyGoalCauseSet('family_goal_cause_set'),
  familyGoalAmountSet('family_goal_amount_set'),
  familyGoalLaunchClicked('family_goal_launch_clicked'),
  familyGoalLaunchedCloseClicked('family_goal_launched_close_clicked'),
  editPaymentDetailsClicked('edit_payment_details_clicked'),
  editPaymentDetailsCanceled('edit_payment_details_canceled'),
  editPaymentDetailsSuccess('edit_payment_details_success'),
  editPaymentDetailsFailure('edit_payment_details_failure'),
  editPaymentDetailsConfirmationDialogClosed(
    'edit_payment_details_confirmation_dialog_closed',
  ),
  utm('utm'),
  giveToFamilyGoalDirectly('give_to_family_goal_directly'),
  skipBiometricWhenRegistered('skip_biometric_when_registered'),
  activateBiometricWhenRegistered('activate_biometric_when_registered'),
  skipBiometricWhenLoggedIn('skip_biometric_when_logged_in'),
  activateBiometricWhenLoggedIn('activate_biometric_when_logged_in'),
  invitedToImpactGroupBottomSheetShown(
    'invited_to_impact_group_bottom_sheet_shown',
  ),
  inviteToImpactGroupAccepted('invite_to_impact_group_accepted'),

  // generosity challenge
  openedGenerosityChallengeNotification(
    'opened_generosity_challenge_notification',
  ),
  giveWithCoinInChallengeClicked('give_with_coin_in_challenge_clicked'),
  generosityChallengeDayClicked('generosity_challenge_day_clicked'),
  generosityChallengeDayCompleted('generosity_challenge_day_completed'),
  generosityChallengeDayUndoCompleting(
    'generosity_challenge_day_undo_completing',
  ),
  startAssignmentFromGenerosityChallenge(
    'start_assignment_from_generosity_challenge',
  ),
  daySevenFamilyValuesSeenContinueClicked(
    'day_7_family_values_seen_continue_clicked',
  ),
  generosityChallengeDonationSuccess('generosity_challenge_donation_success'),
  familyValuesSelected('family_values_selected'),
  acceptedGenerosityChallengeClicked('accepted_generosity_challenge_clicked'),
  generosityChallengeDay8MaybeLaterClicked(
    'generosity_challenge_day_8_maybe_later_clicked',
  ),
  generosityChallengeVPCAccepted('generosity_challenge_vpc_accepted'),
  generosityChallengeAllowanceSet('generosity_challenge_allowance_set'),
  generosityChallengeNavigatedToFamilyOverview(
    'generosity_challenge_navigated_to_family_overview',
  ),
  generosityChallengeNavigatedToWelcome(
    'generosity_challenge_navigated_to_welcome',
  ),
  organisationCardClicked('organisation_card_clicked'),
  organisationDetailsContinueClicked('organisation_details_continue_clicked'),
  sliderAmountChanged('slider_amount_changed'),
  chooseAmountDonateClicked('choose_amount_donate_clicked'),
  redirectCoinToNoAppFlow('redirect_coin_to_noapp_flow'),
  generosityChallengeChatUserAction('generosity_challenge_chat_user_action'),
  generosityChallengeRegistrationSucceeded(
    'generosity_challenge_registration_succeeded',
  ),
  generosityChallengeUploadPictureClicked(
    'generosity_challenge_upload_picture_clicked',
  ),
  generosityChallengeTakePictureClicked(
    'generosity_challenge_take_picture_clicked',
  ),
  generosityChallengeDay4TimerStarted(
    'generosity_challenge_day_4_timer_started',
  ),
  generosityChallengeDay4TimerEnded('generosity_challenge_day_4_timer_ended'),
  generosityChallengeDay4SaveClicked('generosity_challenge_day_4_save_clicked'),
  generosityChallengechatBarButtonClicked(
    'generosity_challenge_chat_bar_button_clicked',
  ),
  generosityChallengeGoToChatClicked('generosity_challenge_go_to_chat_clicked'),

  // Registration flow
  continueByEmailSignUpNewUserCliked(
    'continue_by_email_sign_up_new_user_clicked',
  ),
  continueByEmailSignUpTempUserClicked(
    'continue_by_email_sign_up_temp_user_clicked',
  ),
  registrationFilledInPersonalInfoSheetFilled(
    'registration_filled_in_personal_info_sheet_filled',
  ),
  registrationStripeSheetFilled(
    'registration_stripe_sheet_filled',
  ),
  registrationStripeSheetIncompleteClosed(
    'registration_stripe_sheet_incomplete_closed',
  ),
  registrationSuccesButtonClicked(
    'registration_success_button_clicked',
  ),
  registrationEnterPaymentDetailsClicked(
    'registration_enter_payment_details_clicked',
  ),
  // Family

  amountPressed('amount_pressed'),
  backButtonPressed('back_button_pressed'),
  returnToHomePressed('return_to_home_pressed'),
  giveToThisGoalPressed('give_to_this_goal_pressed'),
  iWantToGivePressed('i_want_to_give_pressed'),
  choseGiveWithCoin('chose_give_with_coin'),
  choseGiveWithQRCode('chose_give_with_qr_code'),
  cancelGive('cancel_give'),
  helpMeFindCharityPressed('help_me_find_charity_pressed'),
  askToFindCharityPressed('ask_my_parents_to_find_charity_pressed'),
  loginPressed('login_pressed'),
  logoutClicked('log_out_pressed'),
  terminateAccountSuccess('terminate_account_success'),
  profilePressed('profile_pressed'),
  profileSwitchPressed('profile_switch_pressed'),
  assignCoinPressed('assign_coin_pressed'),
  qrCodeScanned('qr_code_scanned'),
  seeDonationHistoryPressed('see_donation_history_pressed'),
  locationSelected('location_selected'),
  citySelected('city_selected'),
  interestSelected('interest_selected'),
  showCharitiesPressed('show_charities_pressed'),
  charitiesShown('charities_shown'),
  donateToRecommendedCharityPressed('donate_to_recommended_charity_pressed'),
  charityCardPressed('charity_card_pressed'),
  accountLocked('account_locked_for_wrong_password'),
  walletTracker('wallet_tracker'),
  parentProfileIconClicked('parent_profile_icon_clicked'),
  mySettingsClicked('my_settings_clicked'),

  // NFC Coin flow
  startScanningCoin('in_app_start_scanning_coin'),
  inAppCoinScannedSuccessfully('in_app_coin_scanned_successfully'),
  coinScannedError('in_app_coin_scanned_error'),
  deeplinkCoinScanned('deeplink_coin_scanned'),
  nfcStartButtonClicked('nfc_start_button_clicked'),
  nfcGoToSettingsClicked('nfc_go_to_settings_clicked'),
  notAGivtCoinNFCErrorShown('not_a_givt_coin_nfc_error_shown'),
  coinMediumIdNotRecognized('coin_medium_id_not_recognized'),
  notAGivtCoinNFCErrorGoBackHomeClicked(
    'not_a_givt_coin_nfc_error_go_back_home_clicked',
  ),
  notAGivtCoinNFCErrorTryAgainClicked(
    'not_a_givt_coin_nfc_error_try_again_clicked',
  ),
  coinMediumIdNotRecognizedGoBackHomeClicked(
    'coin_medium_id_not_recognized_go_back_home_clicked',
  ),
  coinMediumIdNotRecognizedTryAgainClicked(
    'coin_medium_id_not_recognized_try_again_clicked',
  ),

  organisationSelected('organisation_is_set'),
  editAvatarIconClicked('edit_avatar_icon_clicked'),
  avatarImageSelected('avatar_image_selected'),
  editProfilePictureClicked('edit_profile_picture_clicked'),
  saveAvatarClicked('save_avatar_clicked'),
  rewardAchieved('reward_achieved'),
  goalTrackerTapped('goal_tracker_tapped'),
  goalDismissed('goal_dismissed'),
  donateToThisFamilyGoalPressed('donate_to_this_family_goal_pressed'),
  choseGiveToFamilyGoal('chose_give_to_family_goal'),
  schoolEventFlowStartButtonClicked('school_event_flow_start_button_clicked'),
  schoolEventFlowLoginButtonClicked('school_event_flow_login_button_clicked'),
  schoolEventFlowConfirmButtonClicked(
    'school_event_flow_confirm_button_clicked',
  ),
  schoolEventLogOutTriggered('school_event_log_out_triggered'),
  permissionsGoToSettingsClicked('open_app_permissions_settings'),
  permissionsNextClicked('next_permissions_clicked'),
  nextPermissionsDialogClicked('next_permissions_dialog_clicked'),
  closePermissionsDialog('close_permissions_dialog'),
  navigationBarPressed('navigation_bar_pressed'),
  impactGroupDetailsReadMoreClicked('impact_group_details_read_more_clicked'),
  impactGroupDetailsGiveClicked('impact_group_details_give_clicked'),
  manageFamilyPressed('manage_family_pressed'),
  registerWithoutChallengeClicked('register_without_challenge_clicked'),
  goToChallengeFromRegistrationClicked(
    'go_to_challenge_from_registration_clicked',
  ),

  bottomsheetCloseButtonClicked('bottomsheet_close_button_clicked'),

  // Topup flow
  topupErrorOkButtonClicked('topup_error_ok_button_clicked'),
  topupGoBackButtonClicked('topup_go_back_button_clicked'),
  topupStartButtonClicked('topup_start_button_clicked'),
  topupConfirmButtonClicked('topup_confirm_button_clicked'),
  topupRecurringCheckboxChanged('topup_recurring_checkbox_changed'),
  topupDoneButtonClicked('topup_done_button_clicked'),

  // Recommendation flow
  recommendationStartButtonClicked('recommendation_start_button_clicked'),
  recommendationInterestsSelected('recommendation_interests_selected'),

  // Parent giving flow
  parentGiveTileClicked('parent_give_tile_clicked'),
  parentGivingFlowOrganisationClicked(
      'parent_giving_flow_organization_clicked'),
  parentGiveWithAmountClicked('parent_give_with_amount_clicked'),
  parentGiveClicked('parent_give_clicked'),

  // Reflect and Share
  reflectandShareAssignRolesClicked('reflect_and_share_assign_roles_clicked'),
  reflectAndShareClicked('reflect_and_share_clicked'),
  reflectAndShareStartClicked('reflect_and_share_start_clicked'),
  reflectAndShareSeeRolesClicked('reflect_and_share_see_roles_clicked'),
  reflectAndShareRulesNextClicked('reflect_and_share_next_clicked'),
  reflectAndShareMemberAdded('reflect_and_share_member_added'),
  reflectAndSharePassThePhoneClicked(
      'reflect_and_share_pass_the_phone_clicked'),
  reflectAndShareReadyClicked('reflect_and_share_ready_clicked'),
  reflectAndShareStartInterviewClicked(
      'reflect_and_share_start_interview_clicked'),
  reflectAndShareDoneClicked('reflect_and_share_done_clicked'),
  reflectAndShareResultGoBackClicked(
      'reflect_and_share_result_go_back_clicked'),
  reflectAndShareNextJournalistClicked(
      'reflect_and_share_next_journalist_clicked'),

  // DEBUG ONLY
  debugButtonClicked('debug_button_clicked'),
  ;

  const AmplitudeEvents(this.value);

  final String value;
}
