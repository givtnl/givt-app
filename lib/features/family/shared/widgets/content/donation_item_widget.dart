import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/history/models/donation_item_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/content/common_history_item_widget.dart';

class DonationItemWidget extends StatelessWidget {
  const DonationItemWidget({required this.uimodel, super.key});
  final DonationItemUIModel uimodel;

  @override
  Widget build(BuildContext context) {
    return CommonHistoryItemWidget(
      leadingSvgAsset: uimodel.leadingSVGAsset,
      amount: uimodel.amount,
      amountColor: uimodel.amountColor,
      title: uimodel.title,
      dateText: uimodel.dateText,
      trailingSvgAsset: uimodel.trailingSvgAsset,
      trailingSvgAssetOpacity: uimodel.trailingSvgAssetOpacity,
    );
  }
}
