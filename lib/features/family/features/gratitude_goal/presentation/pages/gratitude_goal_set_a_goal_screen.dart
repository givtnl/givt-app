import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GratitudeGoalSetAGoalScreen extends StatefulWidget {
  const GratitudeGoalSetAGoalScreen({super.key});

  @override
  State<GratitudeGoalSetAGoalScreen> createState() =>
      _GratitudeGoalSetAGoalScreenState();
}

class _GratitudeGoalSetAGoalScreenState
    extends State<GratitudeGoalSetAGoalScreen> {
  @override
  Widget build(BuildContext context) {
    return const FunScaffold(
      minimumPadding: EdgeInsets.symmetric(horizontal: 24),
      appBar: FunTopAppBar(
        title: 'Gratitude goal',
        leading: GivtBackButtonFlat(),
      ),
      body: Placeholder(),
    );
  }
}
