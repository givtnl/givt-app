import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reflection_rule_reporter_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class ReflectionRuleSuperheroScreen extends StatefulWidget {
  const ReflectionRuleSuperheroScreen({required this.superhero, super.key});

  final GameProfile superhero;

  @override
  State<ReflectionRuleSuperheroScreen> createState() =>
      _ReflectionRuleSuperheroScreenState();
}

class _ReflectionRuleSuperheroScreenState
    extends State<ReflectionRuleSuperheroScreen> {
  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      appBar: const FunTopAppBar(title: 'Reflection rules'),
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
              Navigator.of(context).pushReplacement(
                ReflectionRuleReporterScreen(
                  superhero: widget.superhero,
                ).toRoute(context),
              );
            },
            text: 'Next',
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.reflectAndShareRulesNextClicked,
            ),
          ),
        ),
      ),
    );
  }
}
