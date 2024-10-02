import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reveal_secret_word.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/reporters_widget.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/rule_card.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class RuleScreen extends StatelessWidget {
  const RuleScreen({
    required this.user,
    required this.onTap,
    required this.buttonText,
    required this.bodyText,
    required this.header,
    required this.iconData,
    super.key,
  });

  factory RuleScreen.toSuperhero(GameProfile superhero) {
    return RuleScreen(
      user: superhero,
      header: GameProfileItem(
        profile: superhero,
        displayRole: false,
        size: 100,
      ),
      iconData: FontAwesomeIcons.mask,
      bodyText:
          'Answer questions about your day. Sneak the secret word into 1 answer.',
      onTap: (context) => Navigator.of(context).pushReplacement(
        const RevealSecretWordScreen().toRoute(context),
      ),
      buttonText: 'Reveal secret word',
    );
  }
  factory RuleScreen.toSidekick(GameProfile sidekick) {
    return RuleScreen(
      user: sidekick,
      header: GameProfileItem(
        profile: sidekick,
        displayRole: false,
        size: 100,
      ),
      iconData: FontAwesomeIcons.solidHandshake,
      bodyText:
          "Listen to the superhero. Pick what they're grateful for. Guess the secret word",
      onTap: (context) => {
        // TODO: KIDS-1475
      },
      buttonText: 'Next',
    );
  }
  factory RuleScreen.toReporter(List<GameProfile> reporters) {
    String getReportersText(int reportersCount) {
      if (reportersCount == 1) {
        return 'As the reporter you will ask the superhero 3 questions about their day';
      } else {
        return 'The reporters will ask the superhero 3 questions about their day';
      }
    }

    return RuleScreen(
      user: reporters.first,
      header: ReportersWidget(reporters: reporters),
      iconData: FontAwesomeIcons.microphone,
      bodyText: getReportersText(reporters.length),
      onTap: (context) => {
        // TODO: KIDS-1475
      },
      buttonText: 'Next',
    );
  }

  final GameProfile user;
  final void Function(BuildContext context) onTap;
  final String buttonText;
  final String bodyText;
  final Widget header;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: true,
      appBar: FunTopAppBar(
        title: user.role!.name.capitalize(),
        leading: const GivtBackButtonFlat(),
        actions: const [
          LeaveGameButton(),
        ],
      ),
      body: Center(
        child: RuleCard(
          color: user.role!.color.backgroundColor,
          icon: FunIcon(
            iconData: iconData,
            circleColor: user.role!.color.backgroundColor,
            circleSize: 64,
            iconSize: 32,
          ),
          header: header,
          content: BodyMediumText(
            bodyText,
            textAlign: TextAlign.center,
          ),
          button: FunButton(
            onTap: () {
              onTap(context);
            },
            text: buttonText,
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.reflectAndShareRulesNextClicked,
            ),
          ),
        ),
      ),
    );
  }
}
