import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/utils/utils.dart';

class FunButton extends StatelessWidget {
  const FunButton({
    required this.onTap,
    required this.text,
    super.key,
    this.isDisabled = false,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
    this.leadingImage,
    this.backgroundColor = FamilyAppTheme.primary80,
    this.disabledBackgroundColor = FamilyAppTheme.neutralVariant90,
    this.borderColor = FamilyAppTheme.primary30,
    this.fullBorder = false,
    this.amplitudeEvent,
  });

  factory FunButton.secondary({
    required void Function()? onTap,
    required String text,
    required AmplitudeEvents amplitudeEvent,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leftIcon,
    IconData? rightIcon,
    Widget? leadingImage,
  }) {
    return FunButton(
      onTap: onTap,
      text: text,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
      leadingImage: leadingImage,
      backgroundColor: FamilyAppTheme.neutral100,
      disabledBackgroundColor: FamilyAppTheme.neutral100,
      borderColor: FamilyAppTheme.primary80,
      fullBorder: true,
      amplitudeEvent: amplitudeEvent,
    );
  }

  factory FunButton.tertiary({
    required void Function()? onTap,
    required String text,
    required AmplitudeEvents amplitudeEvent,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leftIcon,
    IconData? rightIcon,
    Widget? leadingImage,
  }) {
    return FunButton(
      onTap: onTap,
      text: text,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
      leadingImage: leadingImage,
      backgroundColor: FamilyAppTheme.neutral100,
      borderColor: AppTheme.secondary80,
      amplitudeEvent: amplitudeEvent,
    );
  }

  final void Function()? onTap;
  final bool isDisabled;
  final String text;
  final bool isLoading;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final Widget? leadingImage;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color borderColor;
  final bool fullBorder;
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
      borderColor: borderColor,
      isDisabled: isDisabled,
      borderSize: fullBorder ? 2 : 0.01,
      baseBorderSize: 4,
      child: Container(
        height: 58 - (fullBorder ? 2 : 0),
        width: MediaQuery.sizeOf(context).width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDisabled ? FamilyAppTheme.neutralVariant60 : backgroundColor,
        ),
        child: Container(
          // Inner container to fix the inside border
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isDisabled ? disabledBackgroundColor : backgroundColor,
          ),
          child: getChild(context, themeData),
        ),
      ),
    );
  }

  Widget getChild(BuildContext context, ThemeData themeData) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingImage != null) leadingImage!,
        if (leftIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FaIcon(
              leftIcon,
              size: 24,
              color: isDisabled
                  ? FamilyAppTheme.neutralVariant60
                  : FamilyAppTheme.primary30,
            ),
          ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: isDisabled == true
              ? themeData.textTheme.labelLarge?.copyWith(
                  color: FamilyAppTheme.neutralVariant60,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Rouna',
                )
              : themeData.textTheme.labelLarge?.copyWith(
                  color: FamilyAppTheme.primary30,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Rouna',
                ),
        ),
        if (rightIcon != null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: FaIcon(
              rightIcon,
              size: 24,
              color: isDisabled ? FamilyAppTheme.neutralVariant60 : borderColor,
            ),
          ),
        // all leading images must be 32 pixels wide
        // this centers the text
        if (leadingImage != null) const SizedBox(width: 32),
      ],
    );
  }
}
