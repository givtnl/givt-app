import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_goal_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_goal_card_ui_model.dart';

class NoGoalSetWidget extends StatelessWidget {
  const NoGoalSetWidget({
    required this.onTap,
    super.key,
  });
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FunGoalCard(
      uiModel: FunGoalCardUIModel(
        title: 'Create a Family Goal',
        description: 'Give together',
        headerIcon: FontAwesomeIcons.solidFlag,
      ),
      onTap: onTap,
    );
  }
}
