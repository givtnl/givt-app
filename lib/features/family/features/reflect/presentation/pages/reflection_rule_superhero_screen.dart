import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reflection_rule_reporter_screen.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_card.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/layout/top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/buttons/fun_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class ReflectionRuleSuperheroScreen extends StatefulWidget {
  const ReflectionRuleSuperheroScreen({super.key});

  @override
  State<ReflectionRuleSuperheroScreen> createState() =>
      _ReflectionRuleSuperheroScreenState();
}

class _ReflectionRuleSuperheroScreenState
    extends State<ReflectionRuleSuperheroScreen> {
  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const TopAppBar(title: 'Reflection rules'),
      body: Center(
        child: FunCard(
          icon: FunIcon.mask(),
          title: 'Superhero',
          content: const BodyMediumText(
            'You’re in the spotlight! You will be asked some questions about your day whilst you try to sneak in a secret word into your answers.',
            textAlign: TextAlign.left,
          ),
          button: FunButton(
            onTap: () {
              Navigator.of(context).push(
                const ReflectionRuleReporterScreen().toRoute(context),
              );
            },
            text: 'Next',
          ),
        ),
      ),
    );
  }
}
