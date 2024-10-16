import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/interview_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/gratitude_selection_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/record_answer_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reveal_secret_word.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/stage_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/reporters_widget.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/rule_card.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
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
          "I'm the superhero! I'll answer questions about my day and sneak a secret word into one of my answers.",
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
          "I'm the sidekick! I'll listen to the superhero's answers and try to guess their secret word at the end.",
      onTap: (context) {
        final reporters = getIt<InterviewCubit>().getReporters();
        Navigator.of(context).pushReplacement(
          PassThePhone.toReporters(reporters).toRoute(context),
        );
      },
      buttonText: 'Next',
    );
  }

  factory RuleScreen.toReporters(List<GameProfile> reporters) {
    final cubit = getIt<InterviewCubit>();

    return RuleScreen(
      user: reporters.first,
      header: ReportersWidget(reporters: reporters),
      iconData: FontAwesomeIcons.microphone,
      bodyText: getReportersText(reporters.length),
      buttonText: 'Next',
      onTap: (context) {
        Navigator.pushReplacement(
          context,
          StageScreen(
            buttonText: "It's showtime!",
            onClickButton: (context) {
              _goToRecordAnswerScreen(context, cubit);
            },
          ).toRoute(context),
        );
      },
    );
  }

  static void _goToRecordAnswerScreen(
      BuildContext context, InterviewCubit cubit) {
    Navigator.of(context).pushReplacement(
      BaseStateConsumer(
        cubit: cubit..init(),
        onInitial: (context) => const SizedBox.shrink(),
        onCustom: handleCustom,
        onData: (context, uiModel) {
          return RecordAnswerScreen(
            uiModel: uiModel,
          );
        },
      ).toRoute(context),
    );
  }

  static void handleCustom(BuildContext context, InterviewCustom custom) {
    switch (custom) {
      case final PassThePhoneToSidekick data:
        Navigator.pushReplacement(
          context,
          PassThePhone.toSidekick(data.profile).toRoute(context),
        );
      case GratitudeSelection():
        Navigator.of(context).pushReplacement(
          const GratitudeSelectionScreen().toRoute(context),
        );
    }
  }

  static String getReportersText(int reportersCount) {
    if (reportersCount == 1) {
      return 'I am the reporter! At the start of the game, I will ask the superhero 4 questions about their day.';
    } else {
      return "We're the reporters! At the start of the game, we'll ask the superhero 4 questions about their day.";
    }
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
      canPop: false,
      appBar: FunTopAppBar(
        title: user.role!.name.capitalize(),
        actions: const [
          LeaveGameButton(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 56),
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
      ),
    );
  }
}
