import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/recommendation/interests/cubit/interests_cubit.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class InterestsTally extends StatelessWidget {
  const InterestsTally({
    required this.tally,
    super.key,
  });

  final int tally;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        InterestsState.maxInterests,
        // index + 1 because we start 1 while the index starts at 0
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
            ? FamilyAppTheme.primary70
            : Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Text(
        index.toStringAsFixed(0),
        style: tally >= index
            ? Theme.of(context).textTheme.bodySmall
            : Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }
}
