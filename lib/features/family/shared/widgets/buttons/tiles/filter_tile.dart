import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/tiles/quick_tile.dart';
import 'package:givt_app/l10n/l10n.dart';

class FilterTile extends StatelessWidget {
  const FilterTile({
    super.key,
    this.edgeInsets,
    this.isSelected = false,
    this.type = CollectGroupType.none,
    this.iconPath,
    this.onClick,
    this.analyticsEventName,
  });

  final EdgeInsets? edgeInsets;
  final CollectGroupType type;
  final String? iconPath;
  final bool isSelected;
  final void Function(BuildContext context)? onClick;

  /// Defaults to the parent-giving filter event. Other flows pass their own
  /// name so taps are not attributed to parent giving.
  final AnalyticsEventName? analyticsEventName;

  @override
  Widget build(BuildContext context) => Padding(
    padding: edgeInsets ?? EdgeInsets.zero,
    child: QuickTile(
      onClick: (context) => onClick?.call(context),
      isSelected: isSelected,
      colorCombo: CollectGroupType.getColorComboByType(type),
      iconPath: iconPath ?? '',
      iconData: iconPath == null
          ? CollectGroupType.getIconByTypeUS(type)
          : null,
      titleBig: type.localizedOrganisationFilterTitle(context.l10n),
      analyticsEvent:
          (analyticsEventName ?? AnalyticsEventName.parentGiveFilterTileClicked)
              .toEvent(
                parameters: {
                  'type': type.name,
                  'isSelected': isSelected,
                },
              ),
    ),
  );
}
