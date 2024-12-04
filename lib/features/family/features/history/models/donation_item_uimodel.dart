import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/string_datetime_extension.dart';

class DonationItemUIModel {
  const DonationItemUIModel(this.context, {required this.donation});

  final ChildDonation donation;
  final BuildContext context;
  String get leadingSVGAsset => DonationState.getPicture(donation.state);
  double get amount => donation.amount;
  Color get amountColor => DonationState.getAmountColor(donation.state);
  String get title => '${donation.isToGoal ? 'Family Goal: ' : ''}'
      '${donation.organizationName}';
  String get dateText => donation.state == DonationState.pending
      ? 'Waiting for approval...'
      : donation.date.formatDate(context.l10n);
  String get trailingSvgAsset =>
      donation.medium == DonationMediumType.nfc || donation.isToGoal
          ? donation.isToGoal
              ? 'assets/family/images/goal_flag.svg'
              : 'assets/family/images/coin.svg'
          : '';
  double get trailingSvgAssetOpacity =>
      donation.state == DonationState.pending ? 0.6 : 1.0;
}
