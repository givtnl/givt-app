import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/utils/utils.dart';

class FunButton extends StatelessWidget {
  const FunButton({
    required this.onTap,
    required this.text,
    required this.analyticsEvent,
    super.key,
    this.isDisabled = false,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
    this.leadingImage,
    this.backgroundColor = FamilyAppTheme.primary80,
    this.disabledBackgroundColor = FamilyAppTheme.neutralVariant90,
    this.borderColor = FamilyAppTheme.primary30,
    this.textColor = FamilyAppTheme.primary30,
    this.fullBorder = false,
    this.isDebugOnly = false,
  });

  factory FunButton.secondary({
    required void Function()? onTap,
    required String text,
    required AnalyticsEvent analyticsEvent,
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
      analyticsEvent: analyticsEvent,
    );
  }

  factory FunButton.tertiary({
    required void Function()? onTap,
    required String text,
    required AnalyticsEvent analyticsEvent,
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
      analyticsEvent: analyticsEvent,
    );
  }

  factory FunButton.destructive({
    required void Function()? onTap,
    required String text,
    required AnalyticsEvent analyticsEvent,
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
      backgroundColor: FamilyAppTheme.error80,
      borderColor: AppTheme.error30,
      textColor: AppTheme.error30,
      analyticsEvent: analyticsEvent,
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
  final Color? textColor;
  final bool fullBorder;
  final bool isDebugOnly;
  final AnalyticsEvent? analyticsEvent;

  @override
  Widget build(BuildContext context) {
    final appConfig = getIt.get<AppConfig>();
    final themeData = const FamilyAppTheme().toThemeData();

    if (isDebugOnly && !appConfig.isTestApp) {
      return const SizedBox.shrink();
    }

    return ActionContainer(
      onTap: () {
        if (analyticsEvent != null) {
          AnalyticsHelper.logEvent(
            eventName: analyticsEvent!.name,
            eventProperties: analyticsEvent!.parameters,
          );
        }

        onTap?.call();
      },
      borderColor: borderColor,
      isDisabled: isDisabled,
      borderSize: fullBorder ? 2 : 0.01,
      baseBorderSize: 4,
      child: Container(
        height: 58 - (fullBorder ? 2 : 0),
        width: MediaQuery.sizeOf(context).width,
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
              color: isDisabled ? FamilyAppTheme.neutralVariant60 : textColor,
            ),
          ),
        Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: isDisabled == true
              ? themeData.textTheme.labelLarge?.copyWith(
                  color: FamilyAppTheme.neutralVariant60,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Rouna',
                )
              : themeData.textTheme.labelLarge?.copyWith(
                  color: textColor,
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
