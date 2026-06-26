import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

/// Chart segment fill colors aligned with Figma (lighter tints).
Color categoryColor(BuildContext context, GivingCategory category) {
  final theme = FunTheme.of(context);
  return switch (category) {
    GivingCategory.charity => theme.tertiary80,
    GivingCategory.church => theme.primary80,
    GivingCategory.campaign => theme.highlight90,
    GivingCategory.other => theme.secondary90,
  };
}

CollectGroupType _collectGroupTypeFor(GivingCategory category) {
  return switch (category) {
    GivingCategory.church => CollectGroupType.church,
    GivingCategory.charity => CollectGroupType.charities,
    GivingCategory.campaign => CollectGroupType.campaign,
    GivingCategory.other => CollectGroupType.artists,
  };
}

FunIcon categoryFunIcon(GivingCategory category) {
  return CollectGroupType.getFunIconByType(_collectGroupTypeFor(category))
      .copyWith(
    circleSize: 48,
    iconSize: 20,
    padding: EdgeInsets.zero,
  );
}

String categoryLabel(BuildContext context, GivingCategory category) {
  final locals = context.l10n;
  return switch (category) {
    GivingCategory.church => locals.personalSummaryCategoryChurch,
    GivingCategory.charity => locals.personalSummaryCategoryCharity,
    GivingCategory.campaign => locals.personalSummaryCategoryCampaign,
    GivingCategory.other => locals.personalSummaryCategoryOther,
  };
}

/// Display order for stacked monthly bars (matches Figma left-to-right).
const monthlyBarCategoryOrder = [
  GivingCategory.charity,
  GivingCategory.church,
  GivingCategory.other,
  GivingCategory.campaign,
];
