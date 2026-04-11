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
  });

  final EdgeInsets? edgeInsets;
  final CollectGroupType type;
  final String? iconPath;
  final bool isSelected;
  final void Function(BuildContext context)? onClick;

  @override
  Widget build(BuildContext context) => Padding(
        padding: edgeInsets ?? EdgeInsets.zero,
        child: QuickTile(
          onClick: (context) => onClick?.call(context),
          isSelected: isSelected,
          colorCombo: CollectGroupType.getColorComboByType(type),
          iconPath: iconPath ?? '',
          iconData:
              iconPath == null ? CollectGroupType.getIconByTypeUS(type) : null,
          titleBig: _localizedFilterTitle(context, type),
          analyticsEvent:
              AnalyticsEventName.parentGiveFilterTileClicked.toEvent(
            parameters: {
              'type': type.name,
              'isSelected': isSelected,
            },
          ),
        ),
      );
}

String _localizedFilterTitle(BuildContext context, CollectGroupType type) {
  final locals = context.l10n;
  switch (type) {
    case CollectGroupType.charities:
      return locals.charity;
    case CollectGroupType.church:
      return locals.church;
    case CollectGroupType.campaign:
      return locals.campaign;
    case CollectGroupType.artists:
    case CollectGroupType.unknown:
    case CollectGroupType.demo:
    case CollectGroupType.debug:
      return locals.other;
    case CollectGroupType.none:
      return type.name[0].toUpperCase() + type.name.substring(1);
  }
}
