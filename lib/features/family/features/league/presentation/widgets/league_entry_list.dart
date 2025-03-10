import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_entry_item.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class LeagueEntryList extends StatelessWidget {
  const LeagueEntryList({
    required this.uiModels,
    this.shrinkWrap = false,
    this.physics,
    super.key,
  });

  final List<LeagueEntryUIModel> uiModels;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemBuilder: (BuildContext context, int index) {
        return LeagueEntryItem(uiModel: uiModels[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Expanded(child: Container(height: 1, color: FamilyAppTheme.neutralVariant95)),
          ],
        );
      },
      itemCount: uiModels.length,
    );
  }
}
