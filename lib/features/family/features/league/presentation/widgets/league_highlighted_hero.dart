import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/rank_widget.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class LeagueHighlightedHero extends StatelessWidget {
  const LeagueHighlightedHero({
    required this.uiModel,
    this.isLarge = false,
    super.key,
  });

  final LeagueEntryUIModel uiModel;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final double size = isLarge ? 120 : 80;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size + 20,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getColor(),
                  ),
                  child: uiModel.avatar != null
                      ? FunAvatar.hero(uiModel.avatar!)
                      : const SizedBox.shrink(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [RankWidget(rank: uiModel.rank)],
                ),
              ),
            ],
          ),
        ),
        if (uiModel.name != null) const SizedBox(height: 8),
        if (uiModel.name != null)
          SizedBox(
            width: 80,
            child: LabelMediumText(
              uiModel.name!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        LabelMediumText(
          '${uiModel.xp} XP',
          color: FamilyAppTheme.primary50,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color? _getColor() {
    if (uiModel.rank == 1) {
      return FamilyAppTheme.highlight90;
    } else if (uiModel.rank == 2) {
      return FamilyAppTheme.neutral90;
    } else if (uiModel.rank == 3) {
      return FamilyAppTheme.info70;
    } else {
      return Colors.transparent;
    }
  }
}
