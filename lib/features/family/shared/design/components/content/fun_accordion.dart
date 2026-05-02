import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_app_theme.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';

/// FUN Accordion
///
/// A collapsible container used to organise related content and guide users
/// through multi-step flows. Only one section should be open at a time.
///
/// This widget is intentionally UI-only – the parent controls which section
/// is expanded by passing [isExpanded] and handling [onHeaderTap].
class FunAccordion extends StatelessWidget {
  const FunAccordion({
    required this.title,
    required this.isExpanded,
    required this.onHeaderTap,
    this.subtitle,
    this.content,
    this.size = FunAccordionSize.medium,
    this.state = FunAccordionState.collapsed,
    this.leadingIcon,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? content;
  final FunAccordionSize size;
  final FunAccordionState state;
  final bool isExpanded;
  final VoidCallback onHeaderTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: _contentBackgroundColor(theme),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _borderColor(theme),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onHeaderTap,
            child: Container(
              decoration: BoxDecoration(
                color: _headerBackgroundColor(theme),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    if (leadingIcon case final icon?) ...[
                      FaIcon(icon, color: _titleColor(theme), size: 18),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleMediumText(
                            title,
                            color: _titleColor(theme),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            BodyMediumText(
                              subtitle!,
                              color: _subtitleColor(theme),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildTrailingIcon(theme),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded && content != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: content,
            ),
        ],
      ),
    );
  }

  Color _headerBackgroundColor(FunAppTheme theme) {
    switch (state) {
      case FunAccordionState.collapsed:
        return theme.neutral98;
      case FunAccordionState.active:
        return isExpanded ? theme.secondary40 : theme.secondary99;
      case FunAccordionState.completed:
        return theme.secondary40;
    }
  }

  Color _contentBackgroundColor(FunAppTheme theme) {
    if (isExpanded) {
      return Colors.white;
    }
    return theme.neutralVariant99;
  }

  Color _borderColor(FunAppTheme theme) {
    switch (state) {
      case FunAccordionState.collapsed:
        return theme.neutral80;
      case FunAccordionState.active:
        return theme.primary40;
      case FunAccordionState.completed:
        return theme.primary40;
    }
  }

  Color _titleColor(FunAppTheme theme) {
    switch (state) {
      case FunAccordionState.collapsed:
        return theme.primary20;
      case FunAccordionState.active:
        return isExpanded ? Colors.white : theme.primary20;
      case FunAccordionState.completed:
        return Colors.white;
    }
  }

  Color _subtitleColor(FunAppTheme theme) {
    switch (state) {
      case FunAccordionState.collapsed:
        return theme.neutral40;
      case FunAccordionState.active:
        return isExpanded
            ? Colors.white.withValues(alpha: 0.9)
            : theme.neutral40;
      case FunAccordionState.completed:
        return Colors.white.withValues(alpha: 0.9);
    }
  }

  Widget _buildTrailingIcon(FunAppTheme theme) {
    if (state == FunAccordionState.completed) {
      return const Icon(
        Icons.check_circle,
        color: Colors.white,
      );
    }

    // Use white icon when header has dark background (active and expanded)
    final iconColor =
        (state == FunAccordionState.active && isExpanded)
            ? Colors.white
            : _titleColor(theme);

    return Icon(
      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      color: iconColor,
    );
  }
}

enum FunAccordionSize {
  medium,
  small,
}

enum FunAccordionState {
  collapsed,
  active,
  completed,
}
