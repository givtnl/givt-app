import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';

class RetryErrorWidget extends StatelessWidget {
  const RetryErrorWidget({
    required this.onTapPrimaryButton,
    super.key,
    this.primaryButtonText = 'Retry',
    this.errorText =
        'Oops, something went wrong. Please check your internet connection.',
    this.secondaryButtonText,
    this.onTapSecondaryButton,
    this.primaryButtonAnalyticsEvent,
    this.secondaryButtonAnalyticsEvent,
  });

  final String? errorText;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final void Function() onTapPrimaryButton;
  final void Function()? onTapSecondaryButton;
  final AnalyticsEvent? primaryButtonAnalyticsEvent;
  final AnalyticsEvent? secondaryButtonAnalyticsEvent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (errorText.isNotNullAndNotEmpty())
              BodyMediumText(
                errorText!,
                textAlign: TextAlign.center,
              ),
            if (errorText.isNotNullAndNotEmpty())
              const SizedBox(
                height: 24,
              ),
            Row(
              children: [
                if (secondaryButtonText.isNotNullAndNotEmpty())
                  Expanded(
                    child: FunButton.secondary(
                      onTap: onTapSecondaryButton,
                      text: secondaryButtonText!,
                      leftIcon: FontAwesomeIcons.arrowRightFromBracket,
                      analyticsEvent: secondaryButtonAnalyticsEvent!,
                    ),
                  ),
                if (secondaryButtonText.isNotNullAndNotEmpty())
                  const SizedBox(
                    width: 16,
                  ),
                Expanded(
                  child: FunButton(
                    onTap: onTapPrimaryButton,
                    text: primaryButtonText,
                    leftIcon: Icons.refresh_rounded,
                    analyticsEvent: primaryButtonAnalyticsEvent ??
                        AnalyticsEvent(
                          AmplitudeEvents.retryClicked,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
