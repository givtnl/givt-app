import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/tiles/quick_tile.dart';

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
          titleBig: type == CollectGroupType.charities
              ? 'Non-profit'
              : type.name[0].toUpperCase() + type.name.substring(1),
        ),
      );
}
