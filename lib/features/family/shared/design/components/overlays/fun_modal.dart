import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class FunModal extends StatelessWidget {
  const FunModal({
    required this.title,
    this.subtitle,
    this.buttons = const [],
    this.icon,
    this.closeAction,
    super.key,
  });

  final FunIcon? icon;
  final String title;
  final String? subtitle;
  final List<FunButton> buttons;

  final VoidCallback? closeAction;

  static Future<void> showAsDialog(
    BuildContext context, {
    required String title,
    String? subtitle,
    List<FunButton> buttons = const [],
    FunIcon? icon,
    VoidCallback? closeAction,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FunModal(
        title: title,
        subtitle: subtitle,
        buttons: buttons,
        icon: icon,
        closeAction: closeAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              showCloseButton(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  children: [
                    // Optional Icon
                    if (icon != null) icon!,

                    const SizedBox(height: 16),

                    // Title
                    TitleMediumText(
                      title,
                      textAlign: TextAlign.center,
                    ),

                    // Subtitle
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: BodyMediumText(
                          subtitle!,
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 16),

                    showButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
              eventName: AmplitudeEvents.modalCloseButtonClicked,
            );

            closeAction!.call();
          },
        ),
      ],
    );
  }

  Widget showButtons() {
    return Column(
      children: [
        for (int i = 0; i < buttons.length; i++)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
            child: buttons[i],
          ),
      ],
    );
  }

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }
}
