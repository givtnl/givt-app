import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class FunModal extends StatefulWidget {
  const FunModal({
    required this.title,
    this.subtitle,
    this.buttons = const [],
    this.icon,
    this.closeAction,
    this.autoClose,
    super.key,
  });

  final Widget? icon;
  final String? title;
  final String? subtitle;
  final List<FunButton> buttons;
  final Duration? autoClose;

  final VoidCallback? closeAction;

  @override
  State<FunModal> createState() => _FunModalState();

  Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }
}

class _FunModalState extends State<FunModal> {
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();

    if (widget.autoClose != null) {
      _autoCloseTimer = Timer(widget.autoClose!, () {
        widget.closeAction?.call();
      });
    }
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
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
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    children: [
                      // Optional Icon
                      if (widget.icon != null) widget.icon!,
                
                      const SizedBox(height: 16),
                
                      // Title
                      if (widget.title != null)
                        TitleMediumText(
                          widget.title!,
                          textAlign: TextAlign.center,
                        ),
                
                      // Subtitle
                      if (widget.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: BodyMediumText(
                            widget.subtitle!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                
                      const SizedBox(height: 16),
                
                      showButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget showCloseButton() {
    if (widget.closeAction == null) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.xmark),
          onPressed: () {
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.modalCloseButtonClicked,
            );
            _autoCloseTimer?.cancel();
            widget.closeAction!.call();
          },
        ),
      ],
    );
  }

  Widget showButtons() {
    return Column(
      children: [
        for (int i = 0; i < widget.buttons.length; i++)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
            child: widget.buttons[i],
          ),
      ],
    );
  }
}
