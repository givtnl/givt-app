import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/rank_widget.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class LeagueEntryItem extends StatelessWidget {
  const LeagueEntryItem({required this.uiModel, super.key});

  final LeagueEntryUIModel uiModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 24),
        RankWidget(rank: uiModel.rank),
        const SizedBox(width: 12),
        if (uiModel.imageUrl != null)
          SvgPicture.network(
            uiModel.imageUrl!,
            width: 40,
            height: 40,
          ),
        const SizedBox(width: 16),
        if (uiModel.name != null) LabelMediumText(uiModel.name!),
        const Spacer(),
        LabelMediumText(
          '${uiModel.xp} XP',
          color: FamilyAppTheme.primary50,
        ),
        const SizedBox(width: 40),
      ],
    );
  }
}
