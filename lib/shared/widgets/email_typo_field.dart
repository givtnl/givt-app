import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_small_text.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/email_typo_helper.dart';

/// Email field plus a non-blocking “did you mean” hint.
///
/// [fieldBuilder] receives the focus node this widget listens to. Pass it
/// into [InputFormField] or [FunInput]. The hint never blocks submit.
class EmailTypoField extends StatefulWidget {
  const EmailTypoField({
    required this.controller,
    required this.fieldBuilder,
    required this.screen,
    this.countryCode,
    this.readOnly = false,
    this.onApplied,
    super.key,
  });

  final TextEditingController controller;
  final Widget Function(BuildContext context, FocusNode focusNode) fieldBuilder;

  /// Technical analytics value. Do not pass the email address.
  final String screen;
  final String? countryCode;
  final bool readOnly;

  /// Called after the user taps the suggestion and the controller is updated.
  /// Programmatic text changes do not fire the field's `onChanged`.
  final ValueChanged<String>? onApplied;

  @override
  State<EmailTypoField> createState() => _EmailTypoFieldState();
}

class _EmailTypoFieldState extends State<EmailTypoField> {
  final FocusNode _focusNode = FocusNode();
  String? _suggestion;
  String? _dismissedFor;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_reevaluate);
    _focusNode.addListener(_reevaluate);
  }

  @override
  void didUpdateWidget(covariant EmailTypoField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_reevaluate);
      widget.controller.addListener(_reevaluate);
    }
    if (oldWidget.countryCode != widget.countryCode ||
        oldWidget.readOnly != widget.readOnly) {
      _reevaluate();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_reevaluate);
    _focusNode
      ..removeListener(_reevaluate)
      ..dispose();
    super.dispose();
  }

  void _reevaluate() {
    if (!mounted) {
      return;
    }
    final next = _computeSuggestion();
    if (next == _suggestion) {
      return;
    }
    setState(() => _suggestion = next);
  }

  String? _computeSuggestion() {
    if (widget.readOnly) {
      return null;
    }
    final text = widget.controller.text;
    if (_dismissedFor != null && text != _dismissedFor) {
      _dismissedFor = null;
    }
    if (text == _dismissedFor) {
      return null;
    }
    final country = widget.countryCode;
    return EmailTypoHelper.suggestEmail(
      text,
      countryCode: (country == null || country.isEmpty) ? null : country,
      allowPrefixMatches: !_focusNode.hasFocus,
    );
  }

  void _accept(String suggestion) {
    widget.controller.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.collapsed(offset: suggestion.length),
    );
    _dismissedFor = null;
    widget.onApplied?.call(suggestion);
    _log(AnalyticsEventName.emailTypoSuggestionAccepted);
  }

  void _dismiss() {
    _dismissedFor = widget.controller.text;
    setState(() => _suggestion = null);
    _log(AnalyticsEventName.emailTypoSuggestionDismissed);
  }

  void _log(AnalyticsEventName name) {
    AnalyticsHelper.logEvent(
      eventName: name,
      eventProperties: {'screen': widget.screen},
    ).catchError((Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = _suggestion;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.fieldBuilder(context, _focusNode),
        if (suggestion != null) ...[
          const SizedBox(height: 8),
          _EmailTypoHint(
            suggestion: suggestion,
            onAccept: () => _accept(suggestion),
            onDismiss: _dismiss,
          ),
        ],
      ],
    );
  }
}

class _EmailTypoHint extends StatelessWidget {
  const _EmailTypoHint({
    required this.suggestion,
    required this.onAccept,
    required this.onDismiss,
  });

  final String suggestion;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final baseStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: theme.primary40,
    );
    final linkStyle = baseStyle?.copyWith(
      color: theme.primary30,
      decoration: TextDecoration.underline,
    );
    final message = context.l10n.emailTypoSuggestion(suggestion);
    final emailIndex = message.indexOf(suggestion);

    return Wrap(
      spacing: 12,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Semantics(
          identifier: 'email-typo-suggestion',
          button: true,
          child: GestureDetector(
            key: const Key('email-typo-suggestion'),
            onTap: onAccept,
            child: Text.rich(
              _suggestionSpan(
                message: message,
                emailIndex: emailIndex,
                baseStyle: baseStyle,
                linkStyle: linkStyle,
              ),
            ),
          ),
        ),
        Semantics(
          identifier: 'email-typo-dismiss',
          button: true,
          child: GestureDetector(
            key: const Key('email-typo-dismiss'),
            onTap: onDismiss,
            child: BodySmallText(
              context.l10n.emailTypoDismiss,
              color: theme.primary40,
            ),
          ),
        ),
      ],
    );
  }

  TextSpan _suggestionSpan({
    required String message,
    required int emailIndex,
    required TextStyle? baseStyle,
    required TextStyle? linkStyle,
  }) {
    if (emailIndex < 0) {
      return TextSpan(text: message, style: baseStyle);
    }
    return TextSpan(
      style: baseStyle,
      children: [
        TextSpan(text: message.substring(0, emailIndex)),
        TextSpan(text: suggestion, style: linkStyle),
        TextSpan(text: message.substring(emailIndex + suggestion.length)),
      ],
    );
  }
}
