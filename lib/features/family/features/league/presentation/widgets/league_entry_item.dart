import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/rank_widget.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class LeagueEntryItem extends StatelessWidget {
  const LeagueEntryItem({required this.uiModel, super.key});

  final LeagueEntryUIModel uiModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        children: [
          RankWidget(rank: uiModel.rank),
          const SizedBox(width: 12),
          if (uiModel.avatar != null) FunAvatar.hero(uiModel.avatar!, size: 40),
          const SizedBox(width: 16),
          if (uiModel.name != null) LabelMediumText(uiModel.name!),
          const Spacer(),
          LabelMediumText(
            '${uiModel.xp} XP',
            color: FamilyAppTheme.primary50,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
