import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/tiles/quick_tile.dart';

class CampaignTile extends StatelessWidget {
  const CampaignTile({
    super.key,
    this.edgeInsets,
    this.isSelected = false,
    this.onClick,
  });

  final EdgeInsets? edgeInsets;
  final bool isSelected;
  final void Function(BuildContext context)? onClick;

  @override
  Widget build(BuildContext context) => Padding(
        padding: edgeInsets ?? EdgeInsets.zero,
        child: QuickTile(
          onClick: (context) => onClick?.call(context),
          isSelected: isSelected,
          colorCombo: ColorCombo.highlight,
          iconData: FontAwesomeIcons.ccAmazonPay,
          iconPath: 'assets/family/images/church.svg',
          titleBig: 'Campaign',
        ),
      );
}
