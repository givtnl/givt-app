import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_elevated_secondary_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class SomethingWentWrongDialog extends StatelessWidget {
  const SomethingWentWrongDialog({
    required this.primaryBtnText,
    required this.onClickPrimaryBtn,
    super.key,
    this.secondaryBtnText,
    this.description,
    this.icon,
    this.iconColor,
    this.circleColor,
    this.primaryBtnLeftIcon,
    this.primaryBtnRightIcon,
    this.primaryBtnLeadingImage,
    this.onClickSecondaryBtn,
  });

  final String primaryBtnText;
  final String? secondaryBtnText;
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final Color? circleColor;
  final IconData? primaryBtnLeftIcon;
  final IconData? primaryBtnRightIcon;
  final Widget? primaryBtnLeadingImage;
  final void Function() onClickPrimaryBtn;
  final void Function()? onClickSecondaryBtn;

  static void show(BuildContext context,
      {required String primaryBtnText,
      required void Function() onClickPrimaryBtn,
      String? secondaryBtnText = 'Close',
      String? description = 'Oops, something went wrong',
      IconData? icon,
      Color? iconColor,
      Color? circleColor,
      IconData? primaryLeftIcon,
      IconData? primaryRightIcon,
      Widget? primaryLeadingImage,
      void Function()? onClickSecondaryBtn}) {
    showDialog<void>(
      context: context,
      builder: (context) => SomethingWentWrongDialog(
        primaryBtnText: primaryBtnText,
        onClickPrimaryBtn: onClickPrimaryBtn,
        secondaryBtnText: secondaryBtnText,
        onClickSecondaryBtn: onClickSecondaryBtn,
        primaryBtnLeftIcon: primaryLeftIcon,
        primaryBtnRightIcon: primaryRightIcon,
        primaryBtnLeadingImage: primaryLeadingImage,
        description: description,
        icon: icon,
        iconColor: iconColor,
        circleColor: circleColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon == null)
              warningIcon()
            else
              primaryCircleWithIcon(iconData: icon),
            const SizedBox(height: 24),
            if (description != null)
              Text(
                description!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontFamily: 'Raleway',
                      color: AppTheme.givtBlue,
                      letterSpacing: 0.25,
                    ),
              ),
            const SizedBox(height: 16),
            GivtElevatedButton(
              text: primaryBtnText,
              onTap: onClickPrimaryBtn,
              leftIcon: primaryBtnLeftIcon,
              rightIcon: primaryBtnRightIcon,
              leadingImage: primaryBtnLeadingImage,
            ),
            const SizedBox(height: 16),
            GivtElevatedSecondaryButton(
              text: secondaryBtnText!,
              onTap: onClickSecondaryBtn ?? () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
