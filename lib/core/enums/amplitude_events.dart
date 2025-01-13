enum AmplitudeEvents {
  letsGo('lets_go'),
  loading('loading'),
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
  addMemberTypeSelectorClicked('add_member_type_selector_clicked'),
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

  organisationCardClicked('organisation_card_clicked'),
  organisationDetailsContinueClicked('organisation_details_continue_clicked'),
  sliderAmountChanged('slider_amount_changed'),
  chooseAmountDonateClicked('choose_amount_donate_clicked'),
  redirectCoinToNoAppFlow('redirect_coin_to_noapp_flow'),
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
  registrationContinueAfterPersonalInfoClicked(
    'registration_continue_after_personal_info_clicked',
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
  locationNextClicked('location_next_clicked'),
  citySelected('city_selected'),
  interestSelected('interest_selected'),
  showCharitiesPressed('show_charities_pressed'),
  charitiesShown('charities_shown'),
  donateToRecommendedCharityPressed('donate_to_recommended_charity_pressed'),
  pledgeActOfServiceClicked('pledge_act_of_service_clicked'),
  charityCardPressed('charity_card_pressed'),
  accountLocked('account_locked_for_wrong_password'),
  walletTracker('wallet_tracker'),
  parentProfileIconClicked('parent_profile_icon_clicked'),
  mySettingsClicked('my_settings_clicked'),

  // Change Password
  changePasswordClicked('change_password_clicked'),

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
  manageFamilyPressed('manage_family_pressed'),
  registerWithoutChallengeClicked('register_without_challenge_clicked'),
  goToChallengeFromRegistrationClicked(
    'go_to_challenge_from_registration_clicked',
  ),

  bottomsheetCloseButtonClicked('bottomsheet_close_button_clicked'),

  // BoxOrigin flow
  modalCloseButtonClicked('modal_close_button_clicked'),
  continueChooseChurchClicked('continue_choose_church_clicked'),
  dontHaveABoxClicked('dont_have_a_box_clicked'),
  boxOriginConfirmClicked('box_orign_clicked'),
  boxOriginSelected('box_orign_selected'),

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
    'parent_giving_flow_organization_clicked',
  ),
  parentGiveWithAmountClicked('parent_give_with_amount_clicked'),
  parentGiveClicked('parent_give_clicked'),
  parentGiveFilterTileClicked('parent_give_filter_tile_clicked'),
  parentGaveSuccessfully('parent_gave_successfully'),

  // Reflect and Share
  reflectAndShareAssignRolesClicked('reflect_and_share_assign_roles_clicked'),
  reflectAndShareClicked('reflect_and_share_clicked'),
  reflectAndShareLetsGoClicked('reflect_and_share_lets_go_clicked'),
  assignedFamilyRolesStartClicked('assigned_family_roles_start_clicked'),
  supersShowItsShowtimeClicked('supers_show_its_showtime_clicked'),
  reflectAndShareSeeTheRulesClicked('reflect_and_share_see_the_rules_clicked'),
  reflectAndShareRulesNextClicked('reflect_and_share_next_clicked'),
  reflectAndShareMemberAdded('reflect_and_share_member_added'),
  reflectAndSharePassThePhoneClicked(
    'reflect_and_share_pass_the_phone_clicked',
  ),
  reflectAndShareReadyClicked('reflect_and_share_ready_clicked'),
  reflectAndShareStartInterviewClicked(
    'reflect_and_share_start_interview_clicked',
  ),
  reflectAndShareGuessOptionClicked('reflect_and_share_guess_option_clicked'),
  reflectAndShareGuessTotalAttemptsUntilCorrect(
      'reflect_and_share_guess_total_attempts_until_correct'),
  reflectAndShareQuitClicked(
    'reflect_and_share_quit_clicked',
  ),
  reflectAndShareNextJournalistClicked(
    'reflect_and_share_next_journalist_clicked',
  ),
  reflectAndShareLeaveGameButtonClicked(
    'reflect_and_share_leave_game_button_clicked',
  ),
  reflectAndShareChangeWordClicked('reflect_and_share_change_word_clicked'),
  reflectAndShareConfirmExitClicked('reflect_and_share_confirm_exit_clicked'),
  reflectAndShareKeepPlayingClicked('reflect_and_share_keep_playing_clicked'),
  reflectAndShareResultShuffleRolesClicked(
    'reflect_and_share_result_shuffle_roles_clicked',
  ),
  familyReflectSummaryBackToHome('family_reflect_summary_back_to_home'),
  gratefulTileSubmitted('grateful_tile_submitted'),
  generousTileSubmitted('generous_tile_submitted'),
  generousTileSelected('generous_tile_selected'),
  gratefulTileSelected('grateful_tile_selected'),
  familyReflectSummaryMinutesPlayedClicked(
    'family_reflect_summary_minutes_played_clicked',
  ),
  familyReflectSummaryQuestionsAskedClicked(
    'family_reflect_summary_questions_asked_clicked',
  ),
  parentReflectionFlowOrganisationClicked(
      'parent_reflection_flow_organisation_clicked'),
  familyReflectSummaryGenerousDeedsClicked(
    'family_reflect_summary_generous_deeds_clicked',
  ),

  newActOfGenerosityClicked('new_act_of_generosity_clicked'),
  recommendationTypeSelectorClicked('recommendation_type_selector_clicked'),
  skipGenerosActPressed('skip_generous_act_pressed'),
//beditime
  childBedtimeSet('bedtime_set_clicked'),
  redirectedFromGratitudeGameToBedtimeSelection(
    'redirected_from_gratitude_game_to_bedtime_selection',
  ),
  familyMissionAcceptanceScreenAcceptButtonPressed(
    'family_mission_acceptance_screen_accept_button_pressed',
  ),
  introBedtimeAnimationContinuePressed(
    'intro_bedtime_animation_continue_pressed',
  ),
  familyMissionAcceptanceScreenAcceptLongPressReleaseToAccept(
    'family_mission_acceptance_screen_accept_long_press_release_to_accept',
  ),
  // Family Home Screen
  familyHomeScreenGratitudeGameButtonClicked(
    'family_home_screen_gratitude_game_button_clicked',
  ),
  familyHomeScreenGiveButtonClicked('family_home_screen_give_button_clicked'),
  familyHomeScreenLatestSummaryClicked(
    'family_home_screen_latest_summary_clicked',
  ),
  familyHomeScreenShowSummariesClicked(
    'family_home_screen_show_summaries_clicked',
  ),

  // Fun Counter
  funCounterDecrementClicked('fun_counter_decrement_clicked'),
  funCounterIncrementClicked('fun_counter_increment_clicked'),

  boxOriginSuccessDialogDone('box_orign_success_dialog_done'),

  // Gratitude Summary
  whoDoesBedtimePushYesClicked('who_does_bedtime_push_yes_clicked'),
  whoDoesBedtimePushNoClicked('who_does_bedtime_push_no_clicked'),
  //Bedtime summary
  summaryLeaveMessageClicked(
    'summary_leave_message_clicked',
  ),
  afterGameSummaryDoneClicked('after_game_usmmary_done_clicked'),
  doneRecordingSummaryMessageClicked(
    'done_recording_summary_message_clicked',
  ),

  volumeBottomSheetReadyClicked('volume_bottom_sheet_ready_clicked'),

  //Missions
  missionTabsChanged('mission_tabs_changed'),
  funMissionCardClicked('fun_mission_card_clicked'),
  noGoalSetCardClicked('no_goal_set_card_clicked'),
  goalActiveCardClicked('goal_active_card_clicked'),
  goalCompletedCardClicked('goal_completed_card_clicked'),

  // Audio recording/player
  audioWidgetPlayClicked('audio_widget_play_clicked'),
  audioWidgetPauseOrStopClicked('audio_widget_pause_or_stop_clicked'),
  audioRecordingStarted('audio_recording_started'),
  audioRecordingStopped('audio_recording_stopped'),
  audioRecordingPlayed('audio_recording_played'),
  audioRecordingPlayPaused('audio_recording_play_paused'),
  audioRecordingPlayStopped('audio_recording_play_stopped'),

  // DEBUG ONLY
  debugButtonClicked('debug_button_clicked'),
  ;

  const AmplitudeEvents(this.value);

  final String value;
}
