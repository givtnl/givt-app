import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class FunBottomSheet extends StatelessWidget {
  const FunBottomSheet({
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

  final FunButton? primaryButton;
  final FunButton? secondaryButton;

  final VoidCallback? closeAction;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.fromLTRB(
          0, 0, 0, MediaQuery.of(context).viewInsets.bottom + 40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width - 96,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: TitleMediumText(
                      title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: showCloseButton(),
                ),
              ],
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
              child: Column(
                children: [
                  content,

                  // Extra text above buttons
                  showHeadlineContent(),

                  // Buttons
                  showPrimaryButton(),
                  showSecondaryButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showCloseButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (closeAction == null) const SizedBox(height: 24),
        if (closeAction != null)
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

  void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      builder: (context) => this,
    );
  }
}
