import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/game_summary/presentation/widgets/summary_page.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/parent_summary_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GameSummaryScreen extends StatelessWidget {
  const GameSummaryScreen({required this.uiModel, super.key});
  final SummaryUIModel uiModel;
  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      backgroundColor: FamilyAppTheme.secondary10,
      appBar: const FunTopAppBar(
        color: FamilyAppTheme.secondary10,
        title: 'Summary',
        titleColor: Colors.white,
        leading: GivtBackButtonFlat(
          color: Colors.white,
        ),
      ),
      body: SummaryPage(uiModel: uiModel),
    );
  }
}
