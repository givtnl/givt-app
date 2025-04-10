import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/unlocked_badge/presentation/widgets/unlocked_badge_widget.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart'
    show LabelMediumText;
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
    this.isPressedDown = false,
    this.leftIcon,
    this.leadingImage,
    this.backgroundColor = FamilyAppTheme.primary80,
    this.disabledBackgroundColor = FamilyAppTheme.neutralVariant90,
    this.borderColor = FamilyAppTheme.primary30,
    this.textColor = FamilyAppTheme.primary30,
    this.fullBorder = false,
    this.isDebugOnly = false,
    this.onTapCancel,
    this.onTapUp,
    this.onTapDown,
    this.onLongPress,
    this.onLongPressUp,
    this.size = FunButtonSize.large,
    this.funButtonBadge,
  });

  factory FunButton.secondary({
    required void Function()? onTap,
    required String text,
    required AnalyticsEvent analyticsEvent,
    bool isDisabled = false,
    bool isLoading = false,
    bool isPressedDown = false,
    FunButtonSize size = FunButtonSize.large,
    IconData? leftIcon,
    Widget? leadingImage,
    FunButtonBadge? funButtonBadge,
  }) {
    return FunButton(
      onTap: onTap,
      text: text,
      isDisabled: isDisabled,
      isLoading: isLoading,
      isPressedDown: isPressedDown,
      leftIcon: leftIcon,
      leadingImage: leadingImage,
      backgroundColor: FamilyAppTheme.neutral100,
      disabledBackgroundColor: FamilyAppTheme.neutral100,
      borderColor: FamilyAppTheme.primary80,
      fullBorder: true,
      analyticsEvent: analyticsEvent,
      size: size,
      funButtonBadge: funButtonBadge,
    );
  }

  factory FunButton.tertiary({
    required void Function()? onTap,
    required String text,
    required AnalyticsEvent analyticsEvent,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leftIcon,
    Widget? leadingImage,
    FunButtonBadge? funButtonBadge,
  }) {
    return FunButton(
      onTap: onTap,
      text: text,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leftIcon: leftIcon,
      leadingImage: leadingImage,
      backgroundColor: FamilyAppTheme.neutral100,
      borderColor: AppTheme.secondary80,
      analyticsEvent: analyticsEvent,
      funButtonBadge: funButtonBadge,
    );
  }

  factory FunButton.destructive({
    required void Function()? onTap,
    required String text,
    required AnalyticsEvent analyticsEvent,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leftIcon,
    Widget? leadingImage,
    FunButtonBadge? funButtonBadge,
  }) {
    return FunButton(
      onTap: onTap,
      text: text,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leftIcon: leftIcon,
      leadingImage: leadingImage,
      backgroundColor: FamilyAppTheme.error80,
      borderColor: AppTheme.error30,
      textColor: AppTheme.error30,
      analyticsEvent: analyticsEvent,
      funButtonBadge: funButtonBadge,
    );
  }

  final void Function()? onTap;
  final VoidCallback? onTapCancel;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapDown;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressUp;
  final bool isDisabled;
  final bool isPressedDown;
  final String text;
  final bool isLoading;
  final IconData? leftIcon;
  final Widget? leadingImage;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color borderColor;
  final Color? textColor;
  final bool fullBorder;
  final bool isDebugOnly;
  final FunButtonSize size;
  final AnalyticsEvent analyticsEvent;
  final FunButtonBadge? funButtonBadge;

  @override
  Widget build(BuildContext context) {
    final appConfig = getIt.get<AppConfig>();
    final themeData = const FamilyAppTheme().toThemeData();

    if (isDebugOnly && !appConfig.isTestApp) {
      return const SizedBox.shrink();
    }

    return ActionContainer(
      analyticsEvent: analyticsEvent,
      onTap: onTap,
      onTapCancel: onTapCancel,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onLongPress: onLongPress,
      onLongPressUp: onLongPressUp,
      borderColor: borderColor,
      isDisabled: isDisabled,
      isPressedDown: isPressedDown,
      borderSize: fullBorder ? 2 : 0.01,
      baseBorderSize: 4,
      child: Container(
        height: (size.isLarge ? 58 : 44) - (fullBorder ? 2 : 0),
        width: size.isLarge ? double.infinity : null,
        padding:
            size.isSmall ? const EdgeInsets.symmetric(horizontal: 16) : null,
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
      return const Center(
          child: CircularProgressIndicator(
        key: ValueKey('Splash-Loader'),
      ));
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
              semanticLabel:
                  'icon-${leftIcon?.fontFamily}-${leftIcon?.codePoint}',
              leftIcon,
              size: size.isLarge ? 24 : 16,
              color: isDisabled ? FamilyAppTheme.neutralVariant60 : textColor,
            ),
          ),
        if (size.isLarge)
          LabelLargeText(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            color: isDisabled ? FamilyAppTheme.neutralVariant60 : textColor,
          ),
        if (size.isSmall)
          LabelMediumText(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            color: isDisabled ? FamilyAppTheme.neutralVariant60 : textColor,
          ),
        if (funButtonBadge != null)
          UnlockedBadgeWidget(
            featureId: funButtonBadge!.featureId,
            profileId: funButtonBadge!.profileId,
          ),
        // all leading images must be 32 pixels wide
        // this centers the text
        if (leadingImage != null) const SizedBox(width: 32),
      ],
    );
  }
}

enum FunButtonSize {
  small,
  large,
}

extension on FunButtonSize {
  bool get isLarge => this == FunButtonSize.large;
  bool get isSmall => this == FunButtonSize.small;
}

class FunButtonBadge {
  const FunButtonBadge({
    required this.featureId,
    required this.profileId,
  });

  final String featureId;
  final String profileId;
}
