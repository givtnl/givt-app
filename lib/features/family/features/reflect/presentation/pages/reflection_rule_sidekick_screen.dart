import 'package:flutter/material.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reveal_secret_word.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class ReflectionRuleSidekickScreen extends StatefulWidget {
  const ReflectionRuleSidekickScreen({super.key});

  @override
  State<ReflectionRuleSidekickScreen> createState() =>
      _ReflectionRuleSidekickScreenState();
}

class _ReflectionRuleSidekickScreenState
    extends State<ReflectionRuleSidekickScreen> {
  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(title: 'Reflection rules'),
      body: Center(
        child: FunCard(
          icon: FunIcon.handshake(FamilyAppTheme.tertiary80),
          title: 'Sidekick',
          content: const BodyMediumText(
            'Listen carefully to the superhero and try to guess the secret word at the end.',
            textAlign: TextAlign.left,
          ),
          button: FunButton(
            onTap: () {
              Navigator.of(context).push(
                const RevealSecretWordScreen().toRoute(context),
              );
            },
            text: 'Next',
          ),
        ),
      ),
    );
  }
}
