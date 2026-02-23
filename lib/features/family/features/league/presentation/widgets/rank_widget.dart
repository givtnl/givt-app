import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';

class RankWidget extends StatelessWidget {
  const RankWidget({required this.rank, super.key});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getColor(context),
      ),
      child: LabelLargeText(
        rank.toString(),
      ),
    );
  }

  Color? _getColor(BuildContext context) {
    if (rank == 1) {
      return FunTheme.of(context).highlight90;
    } else if (rank == 2) {
      return FunTheme.of(context).neutral90;
    } else if (rank == 3) {
      return FunTheme.of(context).info70;
    } else {
      return Colors.transparent;
    }
  }
}
