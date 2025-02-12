import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class RankWidget extends StatelessWidget {
  const RankWidget({required this.rank, super.key});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getColor(),
      ),
      child: LabelLargeText(
        rank.toString(),
      ),
    );
  }

  Color? _getColor() {
    if (rank == 1) {
      return FamilyAppTheme.highlight90;
    } else if (rank == 2) {
      return FamilyAppTheme.neutral90;
    } else if (rank == 3) {
      return FamilyAppTheme.info70;
    } else {
      return Colors.transparent;
    }
  }
}
