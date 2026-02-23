import 'package:flutter/material.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class FunTextButton extends StatelessWidget {
  const FunTextButton({
    required this.text,
    required this.analyticsEvent,
    this.onTap,
    super.key,
    this.isDisabled = false,
    this.disabledTextColor = FamilyAppTheme.neutralVariant60,
    this.textColor = FamilyAppTheme.primary30,
    this.isMedium = true,
    this.isDebugOnly = false,
  });

  factory FunTextButton.medium({
    required String text,
    required AnalyticsEvent analyticsEvent,
    void Function()? onTap,
    bool isDisabled = false,
    bool isMedium = true,
  }) {
    return FunTextButton(
      onTap: onTap,
      text: text,
      isDisabled: isDisabled,
      analyticsEvent: analyticsEvent,
      isMedium: isMedium,
    );
  }

  factory FunTextButton.small({
    required String text,
    required AnalyticsEvent analyticsEvent,
    void Function()? onTap,
    bool isDisabled = false,
    bool isMedium = false,
  }) {
    return FunTextButton(
      onTap: onTap,
      text: text,
      isDisabled: isDisabled,
      analyticsEvent: analyticsEvent,
      isMedium: isMedium,
    );
  }

  final void Function()? onTap;
  final bool isDisabled;
  final String text;
  final Color disabledTextColor;
  final Color? textColor;
  final bool isMedium;
  final bool isDebugOnly;
  final AnalyticsEvent analyticsEvent;

  @override
  Widget build(BuildContext context) {
    final appConfig = getIt.get<AppConfig>();

    if (isDebugOnly && !appConfig.isTestApp) {
      return const SizedBox.shrink();
    }

    final hasDisabledState = isDisabled || onTap == null;

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              onTap?.call();
              AnalyticsHelper.logEvent(
                eventName: analyticsEvent.name,
                eventProperties: analyticsEvent.parameters,
              );
            },
      child: isMedium
          ? SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabelLargeText(
                      text,
                      color: hasDisabledState ? disabledTextColor : textColor,
                    ),
                  ],
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LabelMediumText(
                  text,
                  color: hasDisabledState ? disabledTextColor : textColor,
                ),
              ],
            ),
    );
  }
}
