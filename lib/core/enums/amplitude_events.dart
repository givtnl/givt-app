enum AmplitudeEvents {
  letsGo('lets_go'),
  login('login'),
  familyClicked('family_clicked'),
  seeMyFamilyClicked('see_my_family_clicked'),
  addChildProfile('add_child_profile'),
  addParentProfile('add_parent_profile'),
  addMemerClicked('add_member_clicked'),
  memberCreatedSuccesfully('member_created_succesfully'),
  failedToCreateMember('failed_to_create_member'),
  failedToGetVpc('failed_to_get_vpc'),
  failedTopUpNoFunds('failed_top_up_no_funds'),
  allowanceNotSuccessful('allowance_not_successful'),
  backClicked('back_clicked'),
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
  cancelRGA('cancel_reccuring_giving_allowance'),
  failedToCancelRGA('failed_to_cancel_allowance'),
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

  openedGenerosityChallengeNotification(
    'opened_generosity_challenge_notification',
  ),
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
  acceptedGenerosityChallenge('accepted_generosity_challenge'),
  organisationCardClicked('organisation_card_clicked'),
  organisationDetailsContinueClicked('organisation_details_continue_clicked'),
  sliderAmountChanged('slider_amount_changed'),
  chooseAmountDonateClicked('choose_amount_donate_clicked'),
  generosityChallengeChatUserAction('generosity_challenge_chat_user_action'),
  generosityChallengeRegistrationSucceeded(
    'generosity_challenge_registration_succeeded',
  ),
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
  logOutPressed('log_out_pressed'),
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
  startScanningCoin('in_app_start_scanning_coin'),
  inAppCoinScannedSuccessfully('in_app_coin_scanned_successfully'),
  coinScannedError('in_app_coin_scanned_error'),
  deeplinkCoinScanned('deeplink_coin_scanned'),
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
  openAppPermissionsSettings('open_app_permissions_settings'),
  openCameraPermissionDialog('open_camera_permission_dialog'),
  closePermissionsDialog('close_permissions_dialog'),
  navigationBarPressed('navigation_bar_pressed'),

  impactGroupDetailsReadMoreClicked('impact_group_details_read_more_clicked'),
  impactGroupDetailsGiveClicked('impact_group_details_give_clicked'),

  manageFamilyPressed('manage_family_pressed'),
  ;

  const AmplitudeEvents(this.value);
  final String value;
}
