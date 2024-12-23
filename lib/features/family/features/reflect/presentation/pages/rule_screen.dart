import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/background_audio/bloc/background_audio_cubit.dart';
import 'package:givt_app/features/family/features/background_audio/presentation/fun_background_audio_widget.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/interview_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
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
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class RuleScreen extends StatefulWidget {
  const RuleScreen({
    required this.user,
    required this.onTap,
    required this.buttonText,
    required this.bodyText,
    required this.header,
    required this.iconData,
    required this.audioPath,
    this.backgroundColor,
    super.key,
  });

  factory RuleScreen.toSuperhero(GameProfile superhero) {
    return RuleScreen(
      user: superhero,
      audioPath: 'family/audio/superhero_instructions.wav',
      header: GameProfileItem(
        profile: superhero,
        displayRole: false,
        size: 96,
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
      audioPath: 'family/audio/sidekick_instructions.wav',
      backgroundColor: sidekick.sidekickRole!.color.backgroundColor,
      header: GameProfileItem(
        accentColor: sidekick.sidekickRole!.color.accentColor,
        profile: sidekick,
        displayRole: false,
        size: 100,
      ),
      iconData: FontAwesomeIcons.solidHandshake,
      bodyText:
          "I'm the sidekick! I'll listen to the superhero's answers and try to guess their secret word at the end.",
      onTap: (context) {
        final reporters = getIt<InterviewCubit>().getReporters();
        if (sidekick.roles.length > 1) {
          Navigator.of(context).pushReplacement(
            RuleScreen.toReporters(reporters).toRoute(context),
          );
        } else {
          Navigator.of(context).pushReplacement(
            PassThePhone.toReporters(reporters).toRoute(context),
          );
        }
      },
      buttonText: 'Next',
    );
  }

  factory RuleScreen.toReporters(List<GameProfile> reporters) {
    return RuleScreen(
      user: reporters.first,
      audioPath: reporters.length > 1
          ? 'family/audio/reporters_plural_instructions.wav'
          : 'family/audio/reporter_singular_instructions.wav',
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
              Navigator.of(context).pushReplacement(
                const InterviewScreen().toRoute(context),
              );
            },
          ).toRoute(context),
        );
      },
    );
  }

  static String getReportersText(int reportersCount) {
    if (reportersCount == 1) {
      return 'I am the reporter! At the start of the game, I will ask the superhero 4 questions about their day.';
    } else {
      return "We're the reporters! At the start of the game, we'll ask the superhero ${reportersCount > 3 ? reportersCount + 1 : 4} questions about their day.";
    }
  }

  final GameProfile user;
  final void Function(BuildContext context) onTap;
  final String buttonText;
  final String bodyText;
  final Widget header;
  final IconData iconData;
  final Color? backgroundColor;
  final String audioPath;

  @override
  State<RuleScreen> createState() => _RuleScreenState();
}

class _RuleScreenState extends State<RuleScreen> {
  bool _hasPlayedAudio = false;
  bool isFirstRoundofFirstGame = true;
  final BackgroundAudioCubit _cubit = getIt<BackgroundAudioCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.isFirstRoundofFirstGame().then((value) {
      setState(() {
        isFirstRoundofFirstGame = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      appBar: const FunTopAppBar(
        title: 'Game rules',
        actions: [
          LeaveGameButton(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 56),
          child: RuleCard(
            color: widget.backgroundColor ??
                widget.user.role!.color.backgroundColor,
            icon: FunIcon(
              iconData: widget.iconData,
              circleColor: widget.backgroundColor ??
                  widget.user.role!.color.backgroundColor,
              circleSize: 64,
              iconSize: 32,
            ),
            header: widget.header,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                FunBackgroundAudioWidget(
                  isVisible: true,
                  audioPath: widget.audioPath,
                  onPlay: () {
                    setState(() {
                      _hasPlayedAudio = true;
                    });
                  },
                ),
                const SizedBox(height: 8),
                BodyMediumText(
                  widget.bodyText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            button: FunButton(
              isDisabled: !_hasPlayedAudio && isFirstRoundofFirstGame,
              onTap: () {
                widget.onTap(context);
              },
              text: widget.buttonText,
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
