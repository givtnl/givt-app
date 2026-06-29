import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

/// Cream card wrapper used for goal, monthly, and split-bar sections in My giving.
class PersonalSummarySectionCard extends StatelessWidget {
  const PersonalSummarySectionCard({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.borderRadius = 12,
    this.borderWidth = 1,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.highlight99,
        border: Border.all(
          color: theme.neutralVariant90,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Section title and optional subtitle shown above or inside a card.
class PersonalSummarySectionHeader extends StatelessWidget {
  const PersonalSummarySectionHeader({
    required this.title,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSmallText(title),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          BodySmallText(subtitle!, color: theme.neutral50),
        ],
      ],
    );
  }
}

/// White inner card for the donut chart and legend.
class PersonalSummaryInnerCard extends StatelessWidget {
  const PersonalSummaryInnerCard({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: child,
      ),
    );
  }
}
