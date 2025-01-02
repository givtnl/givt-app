import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_goal_card_ui_model.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_bar.dart';
import 'package:givt_app/utils/app_theme.dart';

class FunGoalCard extends StatelessWidget {
  const FunGoalCard({required this.uiModel, super.key});

  final FunGoalCardUIModel uiModel;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: ShapeDecoration(
        color: AppTheme.primary98,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
    ),
    ),
    child:Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            uiModel.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${context.l10n.familyGoalPrefix}\$${uiModel.progress}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: GoalProgressBar(
              amount: uiModel.progress,
            ),
          ),
        ],
      ),),
    );
  }
}
