import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/unlocked_badge/presentation/widgets/unlocked_badge_widget.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart'
    show LabelMediumText;
import 'package:givt_app/features/family/shared/design/theme/fun_app_theme.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

/// Visual variant of the button; used to resolve theme colors when not overridden.
enum FunButtonVariant {
  primary,
  secondary,
  tertiary,
  destructive,
  destructiveSecondary,
}

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
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.pressedBackgroundColor,
    this.borderColor,
    this.textColor,
    this.disabledTextColor,
    this.fullBorder = false,
    this.isDebugOnly = false,
    this.onTapCancel,
    this.onTapUp,
    this.onTapDown,
    this.onLongPress,
    this.onLongPressUp,
    this.size = FunButtonSize.large,
    this.funButtonBadge,
    this.onDisabledTap,
    this.variant = FunButtonVariant.primary,
  });

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
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? pressedBackgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? disabledTextColor;
  final bool fullBorder;
  final FunButtonVariant variant;
  final bool isDebugOnly;
  final FunButtonSize size;
  final AnalyticsEvent analyticsEvent;
  final FunButtonBadge? funButtonBadge;
  final VoidCallback? onDisabledTap;

  /// Resolves theme colors for the current variant when not explicitly provided.
  ({
    Color bg,
    Color disabledBg,
    Color pressedBg,
    Color border,
    Color text,
    Color disabledText,
  }) _themeColors(FunAppTheme theme) {
    return switch (variant) {
      FunButtonVariant.primary => (
          bg: theme.primary80,
          disabledBg: theme.neutral90,
          pressedBg: theme.primary70,
          border: theme.primary30,
          text: theme.primary30,
          disabledText: theme.neutralVariant60,
        ),
      FunButtonVariant.secondary => (
          bg: theme.neutral100,
          disabledBg: theme.neutral100,
          pressedBg: theme.neutral95,
          border: theme.primary80,
          text: theme.primary30,
          disabledText: theme.neutralVariant60,
        ),
      FunButtonVariant.tertiary => (
          bg: theme.neutral100,
          disabledBg: theme.neutral90,
          pressedBg: theme.neutral95,
          border: theme.secondary80,
          text: theme.primary30,
          disabledText: theme.neutralVariant60,
        ),
      FunButtonVariant.destructive => (
          bg: theme.error80,
          disabledBg: theme.neutralVariant90,
          pressedBg: theme.error70,
          border: theme.error30,
          text: theme.error30,
          disabledText: theme.neutral60,
        ),
      FunButtonVariant.destructiveSecondary => (
          bg: theme.neutral100,
          disabledBg: theme.neutral100,
          pressedBg: theme.neutral95,
          border: theme.error70,
          text: theme.error50,
          disabledText: theme.neutral60,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final appConfig = getIt.get<AppConfig>();
    final theme = FunTheme.of(context);
    final themeData = theme.toThemeData();
    final defaults = _themeColors(theme);

    final resolvedBg = backgroundColor ?? defaults.bg;
    final resolvedDisabledBg = disabledBackgroundColor ?? defaults.disabledBg;
    final resolvedPressedBg =
        pressedBackgroundColor ?? defaults.pressedBg;
    final resolvedBorder = borderColor ?? defaults.border;
    final resolvedText = textColor ?? defaults.text;
    final resolvedDisabledText =
        disabledTextColor ?? defaults.disabledText;

    if (isDebugOnly && !appConfig.isTestApp) {
      return const SizedBox.shrink();
    }

    return Theme(
      data: themeData,
      child: ActionContainer(
        analyticsEvent: analyticsEvent,
        onTap: onTap,
        onTapCancel: onTapCancel,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onLongPress: onLongPress,
        onLongPressUp: onLongPressUp,
        borderColor: resolvedBorder,
        isDisabled: isDisabled,
        isPressedDown: isPressedDown,
        borderSize: fullBorder ? theme.borderWidthThin : 0.01,
        baseBorderSize: theme.shadowYSm == 0 ? 0.01 : theme.shadowYSm,
        onDisabledTap: onDisabledTap,
        child: Builder(
          builder: (context) {
            final isPressed =
                ActionContainerPressedScope.maybeOf(context)?.isPressed ??
                    false;
            final effectiveBg = isDisabled
                ? resolvedDisabledBg
                : (isPressed ? resolvedPressedBg : resolvedBg);
            return Container(
              height: (size.isLarge ? 58 : 44) -
                  (fullBorder ? theme.borderWidthThin : 0),
              width: size.isLarge ? double.infinity : null,
              padding: size.isSmall
                  ? const EdgeInsets.symmetric(horizontal: 16)
                  : null,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: effectiveBg,
              ),
              child: Container(
                // Inner container to fix the inside border
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: effectiveBg,
                ),
                child: getChild(
                    context, themeData, resolvedText, resolvedDisabledText),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getChild(
    BuildContext context,
    ThemeData themeData,
    Color resolvedTextColor,
    Color resolvedDisabledTextColor,
  ) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          key: ValueKey('Splash-Loader'),
        ),
      );
    }
    final labelColor =
        isDisabled ? resolvedDisabledTextColor : resolvedTextColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: size.isSmall ? MainAxisSize.min : MainAxisSize.max,
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
              color: labelColor,
            ),
          ),
        if (size.isLarge)
          LabelLargeText(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            color: labelColor,
          ),
        if (size.isSmall)
          LabelMediumText(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            color: labelColor,
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
