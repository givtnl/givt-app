import 'package:flutter/material.dart';
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
        body: Column(
      children: [
        const TitleMediumText('Share and reflect'),
        TitleSmallText.primary40('How was your day?'),
        GivtElevatedButton(onTap: () {}, text: 'Start')
      ],
    ));
  }
}
