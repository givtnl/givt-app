import 'package:flutter/material.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reflection_rule_sidekick_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class ReflectionRuleReporterScreen extends StatefulWidget {
  const ReflectionRuleReporterScreen({super.key});

  @override
  State<ReflectionRuleReporterScreen> createState() =>
      _ReflectionRuleReporterScreenState();
}

class _ReflectionRuleReporterScreenState
    extends State<ReflectionRuleReporterScreen> {
  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(title: 'Reflection rules'),
      body: Center(
        child: FunCard(
          icon: FunIcon.microphone(FamilyAppTheme.secondary90),
          title: 'Reporter',
          content: const BodyMediumText(
            'Each reporter takes turns asking one question to the superhero, then passes the turn to the next reporter. ',
            textAlign: TextAlign.left,
          ),
          button: FunButton(
            onTap: () {
              Navigator.of(context).push(
                const ReflectionRuleSidekickScreen().toRoute(context),
              );
            },
            text: 'Next',
          ),
        ),
      ),
    );
  }
}
