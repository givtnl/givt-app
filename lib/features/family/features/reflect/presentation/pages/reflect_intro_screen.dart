import 'package:flutter/material.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_circle.dart';
import 'package:givt_app/features/family/shared/widgets/layout/top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';

class ReflectIntroScreen extends StatefulWidget {
  const ReflectIntroScreen({super.key});

  @override
  State<ReflectIntroScreen> createState() => _ReflectIntroScreenState();
}

class _ReflectIntroScreenState extends State<ReflectIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return FamilyScaffold(
        appBar: const TopAppBar(title: 'Reflect and share'),
        body: Column(
          children: [
            const TitleMediumText(
                'Build a family habit of reflection, sharing and gratitude.'),
            const FamilyGoalCircle(),
            GivtElevatedButton(onTap: () {}, text: "Let's start"),
          ],
        ));
  }
}
