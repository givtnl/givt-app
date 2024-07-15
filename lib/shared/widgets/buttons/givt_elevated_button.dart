import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/utils/utils.dart';

class GivtElevatedButton extends StatelessWidget {
  const GivtElevatedButton({
    required this.onTap,
    required this.text,
    super.key,
    this.isDisabled = false,
    this.isLoading = false,
    this.isTertiary = false,
    this.leftIcon,
    this.rightIcon,
    this.leadingImage,
    this.widthMultiplier = .9,
  });

  final void Function()? onTap;
  final bool isDisabled;
  final String text;
  final bool isLoading;
  final bool isTertiary;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final Widget? leadingImage;
  final double widthMultiplier;

  @override
  Widget build(BuildContext context) {
    final themeData = FamilyAppTheme().toThemeData();
    return ActionContainer(
      onTap: onTap ?? () {},
      borderColor:
          isTertiary == true ? AppTheme.secondary80 : AppTheme.givtGreen40,
      isDisabled: isDisabled,
      borderSize: 0.01,
      baseBorderSize: 4,
      child: Container(
        height: 58,
        width: MediaQuery.sizeOf(context).width * widthMultiplier,
        decoration: BoxDecoration(
          color: isDisabled
              ? AppTheme.givtGraycece
              : isTertiary == true
                  ? Colors.white
                  : AppTheme.primary80,
        ),
        child: getChild(context, themeData),
      ),
    );
  }

  Widget getChild(BuildContext context, ThemeData themeData) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (leftIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              leftIcon,
              size: 24,
              color: isDisabled
                  ? themeData.colorScheme.outline
                  : AppTheme.givtGreen40,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: isDisabled == true
                ? themeData.textTheme.labelMedium?.copyWith(
                    color: themeData.colorScheme.outline,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  )
                : themeData.textTheme.labelMedium?.copyWith(
                    color: AppTheme.givtGreen40,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  ),
          ),
        ],
      );
    }
    if (rightIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: isDisabled == true
                ? themeData.textTheme.labelMedium?.copyWith(
                    color: themeData.colorScheme.outline,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  )
                : themeData.textTheme.labelMedium?.copyWith(
                    color: AppTheme.givtGreen40,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              rightIcon,
              size: 24,
              color: isDisabled
                  ? themeData.colorScheme.outline
                  : AppTheme.givtGreen40,
            ),
          ),
        ],
      );
    }
    if (leadingImage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leadingImage!,
            Text(
              text,
              textAlign: TextAlign.center,
              style: isDisabled == true
                  ? themeData.textTheme.labelMedium?.copyWith(
                      color: themeData.colorScheme.outline,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    )
                  : themeData.textTheme.labelMedium?.copyWith(
                      color: AppTheme.givtGreen40,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    ),
            ),
            // all leading images must be 32 pixels wide
            // this centers the text
            const SizedBox(width: 32),
          ],
        ),
      );
    }
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: isDisabled == true
            ? themeData.textTheme.labelMedium?.copyWith(
                color: themeData.colorScheme.outline,
                fontWeight: FontWeight.w700,
                fontFamily: 'Rouna',
              )
            : themeData.textTheme.labelMedium?.copyWith(
                color: AppTheme.givtGreen40,
                fontWeight: FontWeight.w700,
                fontFamily: 'Rouna',
              ),
      ),
    );
  }
}
