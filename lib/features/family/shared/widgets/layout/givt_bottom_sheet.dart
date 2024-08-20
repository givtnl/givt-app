import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_secondary_button.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class GivtBottomSheet extends StatelessWidget {
  const GivtBottomSheet({
    required this.title,
    required this.content,
    this.icon,
    this.headlineContent,
    this.primaryButton,
    this.secondaryButton,
    this.closeAction,
    super.key,
  });

  final String title;
  final Widget? icon;
  final Widget content;
  final Widget? headlineContent;

  final GivtElevatedButton? primaryButton;
  final GivtElevatedSecondaryButton? secondaryButton;

  final VoidCallback? closeAction;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            showCloseButton(),
            // Title
            TitleMediumText(
              title,
              textAlign: TextAlign.center,
            ),

            // Icon
            if (icon != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: icon,
                ),
              ),

            if (icon == null) const SizedBox(height: 8),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: content,
            ),

            // Extra text above buttons
            showHeadlineContent(),

            // Buttons
            showPrimaryButton(),
            showSecondaryButton(),
          ],
        ),
      ),
    );
  }

  Widget showCloseButton() {
    if (closeAction == null) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.xmark),
          onPressed: () {
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.bottomsheetCloseButtonClicked,
            );

            closeAction!.call();
          },
        ),
      ],
    );
  }

  Widget showHeadlineContent() {
    if (headlineContent == null) return const SizedBox(height: 24);

    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: headlineContent,
    );
  }

  Widget showPrimaryButton() {
    if (primaryButton == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: primaryButton,
    );
  }

  Widget showSecondaryButton() {
    if (secondaryButton == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: secondaryButton,
    );
  }
}
