enum AmplitudeEvents {
  letsGo('lets_go'),
  login('login'),
  familyClicked('family_clicked'),
  addChildProfile('add_child_profile'),
  backClicked('back_clicked'),
  createChildProfileClicked('create_child_profile_clicked'),
  directNoticeClicked('direct_notice_clicked'),
  enterCardDetailsClicked('enter_card_details_clicked'),
  infoGivingAllowanceClicked('info_giving_allowance_clicked'),
  infoGivingAllowanceDismissed('info_giving_allowance_dismissed'),
  setUpChildProfileClicked('set_up_child_profile_clicked'),
  vpcSuccess('vpc_successful'),
  vpcCancelled('vpc_cancelled'),
  childDetailsEditAppBarClicked('child_details_edit_app_bar_clicked'),
  childDetailsEditCardClicked(
    'child_details_edit_card_clicked',
  ),
  childEditSaveClicked('child_edit_save_clicked'),
  childEditCancelClicked('child_edit_cancel_clicked'),
  childProfileClicked('child_profile_clicked'),
  pendingDonationClicked('pending_donation_clicked'),
  pendingDonationApproved('pending_donation_approved'),
  pendingDonationDeclined('pending_donation_declined'),
  ;

  const AmplitudeEvents(this.value);
  final String value;
}
