import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/theme/fun_app_theme.dart';
import 'package:givt_app/shared/design_system/theme/fun_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

/// Interaction mode for [FunFilterChip], matching the FUN Filter Chip spec.
enum FunFilterChipMode {
  /// Only one chip in a group should be active. Selection is fill color only.
  singleSelection,

  /// Any number of chips can be active. Selected state includes a checkmark.
  multiSelect,

  /// Tapping opens a menu rather than toggling the chip.
  dropdown,
}

/// FUN Filter Chip — single-select, multi-select, and dropdown.
///
/// Selected fill uses the brand teal (`secondary40`) from the Chip DS
/// (`info/info40` in Figma maps to Givt secondary).
class FunFilterChip extends StatefulWidget {
  const FunFilterChip({
    required this.label,
    required this.analyticsEvent,
    this.mode = FunFilterChipMode.singleSelection,
    this.selected = false,
    this.enabled = true,
    this.isExpanded = false,
    this.leadingIcon,
    this.onPressed,
    this.semanticsIdentifier,
    super.key,
  });

  final String label;
  final AnalyticsEvent analyticsEvent;
  final FunFilterChipMode mode;
  final bool selected;
  final bool enabled;
  final bool isExpanded;
  final FaIconData? leadingIcon;
  final VoidCallback? onPressed;
  final String? semanticsIdentifier;

  @override
  State<FunFilterChip> createState() => _FunFilterChipState();
}

class _FunFilterChipState extends State<FunFilterChip> {
  bool _pressed = false;
  bool _focused = false;
  bool _hovered = false;

  bool get _showCheck =>
      widget.mode == FunFilterChipMode.multiSelect && widget.selected;

  bool get _showDropdownChevron => widget.mode == FunFilterChipMode.dropdown;

  bool get _showLeadingIcon => widget.leadingIcon != null && !_showCheck;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final colors = _colors(theme);

    final chip = FocusableActionDetector(
      enabled: widget.enabled,
      onShowFocusHighlight: (focused) {
        if (mounted) {
          setState(() => _focused = focused);
        }
      },
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
        child: GestureDetector(
          onTapDown: widget.enabled
              ? (_) => setState(() => _pressed = true)
              : null,
          onTapUp: widget.enabled
              ? (_) => setState(() => _pressed = false)
              : null,
          onTapCancel: widget.enabled
              ? () => setState(() => _pressed = false)
              : null,
          onTap: widget.enabled
              ? () {
                  unawaited(
                    AnalyticsHelper.logEvent(
                      eventName: widget.analyticsEvent.name,
                      eventProperties: widget.analyticsEvent.parameters,
                    ),
                  );
                  widget.onPressed?.call();
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(999),
              border: colors.border == null
                  ? null
                  : Border.all(
                      color: colors.border!,
                      width: theme.borderWidthThinner,
                    ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_showCheck) ...[
                  FaIcon(
                    FontAwesomeIcons.check,
                    size: 12,
                    color: colors.foreground,
                  ),
                  const SizedBox(width: 4),
                ],
                if (_showLeadingIcon) ...[
                  FaIcon(
                    widget.leadingIcon,
                    size: 12,
                    color: colors.foreground,
                  ),
                  const SizedBox(width: 4),
                ],
                LabelSmallText(widget.label, color: colors.foreground),
                if (_showDropdownChevron) ...[
                  const SizedBox(width: 4),
                  FaIcon(
                    _pressed || widget.isExpanded
                        ? FontAwesomeIcons.chevronUp
                        : FontAwesomeIcons.chevronDown,
                    size: 12,
                    color: colors.foreground,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: widget.enabled,
      selected: widget.selected,
      identifier: widget.semanticsIdentifier ?? widget.label,
      child: Opacity(opacity: widget.enabled ? 1 : 0.7, child: chip),
    );
  }

  ({Color background, Color foreground, Color? border}) _colors(
    FunAppTheme theme,
  ) {
    final selected = widget.selected;
    final disabled = !widget.enabled;

    if (selected && disabled) {
      return (
        background: theme.neutral80,
        foreground: theme.neutral100,
        border: theme.neutral80,
      );
    }
    if (selected && (_pressed || _hovered)) {
      return (
        background: theme.secondary30,
        foreground: theme.neutral100,
        border: null,
      );
    }
    if (selected && _focused) {
      return (
        background: theme.secondary40,
        foreground: theme.neutral100,
        border: theme.secondary30,
      );
    }
    if (selected) {
      return (
        background: theme.secondary40,
        foreground: theme.neutral100,
        border: null,
      );
    }
    if (disabled) {
      return (
        background: theme.neutral98,
        foreground: theme.neutral60,
        border: theme.neutral90,
      );
    }
    if (_pressed || _hovered) {
      return (
        background: theme.neutral90,
        foreground: theme.neutral40,
        border: theme.neutral80,
      );
    }
    if (_focused) {
      return (
        background: theme.neutral100,
        foreground: theme.neutral40,
        border: theme.secondary40,
      );
    }
    return (
      background: theme.neutral100,
      foreground: theme.neutral40,
      border: theme.neutral80,
    );
  }
}
