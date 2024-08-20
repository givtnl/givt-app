import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
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
    return Stack(
      children: [
        SafeArea(
          minimum: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Icon
              showIcon(),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Content
                      content,

                      // Extra text above buttons
                      showHeadlineContent(),

                      // Buttons
                      showPrimaryButton(),
                      showSecondaryButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        showCloseButton(),
      ],
    );
  }

  Widget showIcon() {
    if (icon == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: icon,
    );
  }

  Widget showCloseButton() {
    if (closeAction == null) return const SizedBox.shrink();

    return Positioned(
      top: 12,
      right: 12,
      child: IconButton(
        icon: const FaIcon(FontAwesomeIcons.xmark),
        onPressed: () {
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.bottomsheetCloseButtonClicked,
          );

          closeAction!.call();
        },
      ),
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

  void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      builder: (context) => GivtBottomSheet(
        title: title,
        content: content,
        icon: icon,
        headlineContent: headlineContent,
        primaryButton: primaryButton,
        secondaryButton: secondaryButton,
        closeAction: closeAction,
      ),
    );
  }
}
