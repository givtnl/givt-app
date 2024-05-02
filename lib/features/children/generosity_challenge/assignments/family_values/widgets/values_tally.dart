import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/cubit/family_values_cubit.dart';
import 'package:givt_app/utils/app_theme.dart';

class ValuesTally extends StatelessWidget {
  const ValuesTally({
    required this.tally,
    super.key,
  });

  final int tally;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        FamilyValuesState.maxSelectedValues,
        (index) => _buildTallyIcon(index + 1, context),
      ),
    );
  }

  Widget _buildTallyIcon(int index, BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.only(bottom: 0.5),
      margin: const EdgeInsets.only(right: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: tally >= index
            ? AppTheme.primary70
            : Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Text(
        index.toStringAsFixed(0),
        style: tally >= index
            ? Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'Rouna',
                  fontWeight: FontWeight.w700,
                  color: AppTheme.givtGreen40,
                )
            : Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Rouna',
                ),
      ),
    );
  }
}
