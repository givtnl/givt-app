import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';

class ChildTopUpCard extends StatelessWidget {
  const ChildTopUpCard({
    this.onPressed,
    super.key,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: AppTheme.givtLightBackgroundGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              width: 2,
              color: AppTheme.childGivingAllowanceCardBorder,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              primaryCircleWithIcon(
                circleSize: size.width * 0.35,
                iconData: FontAwesomeIcons.plus,
              ),
              const SizedBox(height: 16),
              Text(
                'One-time Top Up',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                "Add to your child's Wallet",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
