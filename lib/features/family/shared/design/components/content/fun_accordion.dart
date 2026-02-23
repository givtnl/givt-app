import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_small_text.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';

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
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: _contentBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _borderColor,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onHeaderTap,
            child: Container(
              decoration: BoxDecoration(
                color: _headerBackgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (leadingIcon != null) ...[
                      FaIcon(leadingIcon!, color: _titleColor, size: 18,),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleSmallText(
                            title,
                            color: _titleColor,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            LabelMediumText(
                              subtitle!,
                              color: _subtitleColor,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildTrailingIcon(),
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

  Color get _headerBackgroundColor {
    switch (state) {
      case FunAccordionState.collapsed:
        // Use neutral95 for collapsed state background (per Figma design)
        return FamilyAppTheme.neutral95;
      case FunAccordionState.active:
        // When active and expanded, use dark primary color for header
        return isExpanded ? FamilyAppTheme.primary40 : FamilyAppTheme.primary99;
      case FunAccordionState.completed:
        return FamilyAppTheme.primary40;
    }
  }

  Color get _contentBackgroundColor {
    if (isExpanded) {
      return Colors.white;
    }
    // Content area always uses light background
    return FamilyAppTheme.neutralVariant99;
  }

  Color get _borderColor {
    switch (state) {
      case FunAccordionState.collapsed:
        // Use neutral80 for collapsed state border (per Figma design)
        return FamilyAppTheme.neutral80;
      case FunAccordionState.active:
        return FamilyAppTheme.primary40;
      case FunAccordionState.completed:
        return FamilyAppTheme.primary40;
    }
  }

  Color get _titleColor {
    switch (state) {
      case FunAccordionState.collapsed:
        return FamilyAppTheme.primary20;
      case FunAccordionState.active:
        // When active and expanded, use white text on dark header
        return isExpanded ? Colors.white : FamilyAppTheme.primary20;
      case FunAccordionState.completed:
        return Colors.white;
    }
  }

  Color get _subtitleColor {
    switch (state) {
      case FunAccordionState.collapsed:
        return FamilyAppTheme.neutral40;
      case FunAccordionState.active:
        // When active and expanded, use light subtitle on dark header
        return isExpanded
            ? Colors.white.withValues(alpha: 0.9)
            : FamilyAppTheme.neutral40;
      case FunAccordionState.completed:
        return Colors.white.withValues(alpha: 0.9);
    }
  }

  Widget _buildTrailingIcon() {
    if (state == FunAccordionState.completed) {
      return const Icon(
        Icons.check_circle,
        color: Colors.white,
      );
    }

    // Use white icon when header has dark background (active and expanded)
    final iconColor = (state == FunAccordionState.active && isExpanded)
        ? Colors.white
        : _titleColor;

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
