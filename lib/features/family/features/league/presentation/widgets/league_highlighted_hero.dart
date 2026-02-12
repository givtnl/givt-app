import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/rank_widget.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';

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
    final size = isLarge ? 120.0 : 80.0;
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
                    color: _getColor(context),
                  ),
                  child: _getAvatar(uiModel, size),
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
          color: FunTheme.of(context).primary50,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color? _getColor(BuildContext context) {
    if (uiModel.rank == 1) {
      return FunTheme.of(context).highlight90;
    } else if (uiModel.rank == 2) {
      return FunTheme.of(context).neutral90;
    } else if (uiModel.rank == 3) {
      return FunTheme.of(context).info70;
    } else {
      return Colors.transparent;
    }
  }

  FunAvatar _getAvatar(LeagueEntryUIModel uiModel, double size) {
    if (uiModel.avatar != null) {
      return FunAvatar.hero(uiModel.avatar!, size: size - 12);
    }

    if (uiModel.customAvatarUIModel != null) {
      return FunAvatar.custom(uiModel.customAvatarUIModel!, size: size - 12);
    }

    return FunAvatar.defaultHero(size: size - 12);
  }
}
