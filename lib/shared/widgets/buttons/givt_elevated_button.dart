import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
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
    this.backgroundColor = AppTheme.primary80,
    this.borderColor = AppTheme.givtGreen40,
    this.amplitudeEvent,
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
  final Color backgroundColor;
  final Color borderColor;
  final AmplitudeEvents? amplitudeEvent;

  @override
  Widget build(BuildContext context) {
    final themeData = const FamilyAppTheme().toThemeData();
    return ActionContainer(
      onTap: () {
        if (amplitudeEvent != null) {
          AnalyticsHelper.logEvent(eventName: amplitudeEvent!);
        }

        onTap?.call();
      },
      borderColor: isTertiary == true ? AppTheme.secondary80 : borderColor,
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
                  : backgroundColor,
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
              color: isDisabled ? themeData.colorScheme.outline : borderColor,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: isDisabled == true
                ? themeData.textTheme.labelLarge?.copyWith(
                    color: themeData.colorScheme.outline,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  )
                : themeData.textTheme.labelLarge?.copyWith(
                    color: borderColor,
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
                ? themeData.textTheme.labelLarge?.copyWith(
                    color: themeData.colorScheme.outline,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  )
                : themeData.textTheme.labelLarge?.copyWith(
                    color: borderColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              rightIcon,
              size: 24,
              color: isDisabled ? themeData.colorScheme.outline : borderColor,
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
                  ? themeData.textTheme.labelLarge?.copyWith(
                      color: themeData.colorScheme.outline,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    )
                  : themeData.textTheme.labelLarge?.copyWith(
                      color: borderColor,
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
            ? themeData.textTheme.labelLarge?.copyWith(
                color: themeData.colorScheme.outline,
                fontWeight: FontWeight.w700,
                fontFamily: 'Rouna',
              )
            : themeData.textTheme.labelLarge?.copyWith(
                color: borderColor,
                fontWeight: FontWeight.w700,
                fontFamily: 'Rouna',
              ),
      ),
    );
  }
}
