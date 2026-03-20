import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';

class FunInput extends StatelessWidget {
  const FunInput({
    required this.hintText,
    this.onTap,
    this.onChanged,
    this.focusNode,
    this.readOnly = false,
    this.prefixIcon,
    this.analyticsEvent,
    this.heroTag,
    super.key,
  });

  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool readOnly;
  final Widget? prefixIcon;
  final AnalyticsEvent? analyticsEvent;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final input = TextField(
      focusNode: focusNode,
      readOnly: readOnly,
      onTap: () {
        if (analyticsEvent != null) {
          AnalyticsHelper.logEvent(
            eventName: analyticsEvent!.name,
            eventProperties: analyticsEvent!.parameters,
          );
        }
        onTap?.call();
      },
      onChanged: onChanged,
      autocorrect: false,
      cursorColor: theme.primary30,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: theme.neutralVariant60,
        ),
        prefixIcon:
            prefixIcon ??
            Icon(
              Icons.search,
              color: theme.neutral40,
            ),
        filled: true,
        fillColor: theme.neutral100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.neutralVariant80,
            width: theme.borderWidthThinner,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.neutralVariant80,
            width: theme.borderWidthThinner,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.secondary80,
            width: theme.borderWidthThin,
          ),
        ),
      ),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: theme.primary20,
      ),
    );

    if (heroTag == null) {
      return input;
    }

    return Hero(
      tag: heroTag!,
      child: Material(
        type: MaterialType.transparency,
        child: input,
      ),
    );
  }
}
