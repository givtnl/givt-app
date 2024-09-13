import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reflection_rule_sidekick_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_dialog.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class ReflectionRuleReporterScreen extends StatefulWidget {
  const ReflectionRuleReporterScreen({required this.superhero, super.key});

  final GameProfile superhero;

  @override
  State<ReflectionRuleReporterScreen> createState() =>
      _ReflectionRuleReporterScreenState();
}

class _ReflectionRuleReporterScreenState
    extends State<ReflectionRuleReporterScreen> {
  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      appBar: FunTopAppBar(
        title: 'Reflection rules',
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.xmark),
            onPressed: () {
              const LeaveGameDialog().show(context);
            },
          ),
        ],
      ),
      body: Center(
        child: FunCard(
          icon: FunIcon.microphone(circleColor: FamilyAppTheme.secondary90),
          title: 'Reporter',
          content: const BodyMediumText(
            'Each reporter takes turns asking one question to the superhero, then passes the turn to the next reporter. ',
            textAlign: TextAlign.left,
          ),
          button: FunButton(
            onTap: () {
              Navigator.of(context).pushReplacement(
                ReflectionRuleSidekickScreen(superhero: widget.superhero)
                    .toRoute(context),
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
