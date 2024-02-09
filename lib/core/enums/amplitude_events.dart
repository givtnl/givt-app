enum AmplitudeEvents {
  letsGo('lets_go'),
  login('login'),
  familyClicked('family_clicked'),
  addChildProfile('add_child_profile'),
  addParentProfile('add_parent_profile'),
  addMemerClicked('add_member_clicked'),
  memberCreatedSuccesfully('member_created_succesfully'),
  failedToCreateMember('failed_to_create_member'),
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
  childEditSaveClicked('child_edit_save_clicked'),
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
      'annual_overview_receive_via_mail_clicked'),
  setGivingGoalClicked('set_giving_goal_clicked'),
  editGivingGoalClicked('edit_giving_goal_clicked'),
  givingGoalSaved('giving_goal_saved'),
  removeGivingGoalClicked('remove_giving_goal_clicked'),

  recurringDonationsClicked('recurring_donations_clicked'),

  editAvatarPictureClicked('edit_avatar_picture_clicked'),
  editAvatarIconClicked('edit_avatar_icon_clicked'),
  avatarSelected('avatar_selected'),
  avatarSaved('avatar_saved'),

  cacheMembersDueToNoFunds('cache_members_due_to_no_funds'),
  failedToCreateMembersFromCache('failed_to_create_members_from_cache'),
  ;

  const AmplitudeEvents(this.value);
  final String value;
}
