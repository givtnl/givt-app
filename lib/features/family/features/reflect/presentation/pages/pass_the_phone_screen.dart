import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/background_audio/bloc/background_audio_cubit.dart';
import 'package:givt_app/features/family/features/background_audio/presentation/fun_background_audio_widget.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/guess_secret_word_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/interview_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reveal_secret_word.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/rule_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/stage_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/reporters_widget.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class PassThePhone extends StatefulWidget {
  const PassThePhone({
    required this.user,
    required this.onTap,
    required this.audioPath,
    this.accentColor,
    this.backgroundColor,
    this.customHeader,
    super.key,
    this.customBtnText,
  });

  factory PassThePhone.toSuperhero(GameProfile superhero,
      {bool skipRules = false}) {
    return PassThePhone(
      audioPath: 'family/audio/pass_phone_to_superhero.wav',
      user: superhero,
      onTap: (context) => Navigator.of(context).pushReplacement(
        (skipRules
                ? const RevealSecretWordScreen()
                : RuleScreen.toSuperhero(superhero))
            .toRoute(context),
      ),
    );
  }

  factory PassThePhone.toSidekick(GameProfile sidekick,
      {bool toRules = false}) {
    return PassThePhone(
      audioPath: 'family/audio/pass_phone_to_sidekick.wav',
      accentColor: sidekick.sidekickRole!.color.accentColor,
      backgroundColor: sidekick.sidekickRole!.color.backgroundColor,
      user: sidekick,
      onTap: (context) => Navigator.of(context).pushReplacement(
        toRules
            ? RuleScreen.toSidekick(sidekick).toRoute(context)
            : const GuessSecretWordScreen().toRoute(context),
      ),
    );
  }

  factory PassThePhone.toReporters(List<GameProfile> reporters,
      {bool skipRules = false}) {
    return PassThePhone(
      audioPath: 'family/audio/pass_phone_to_the_reporter.wav',
      user: reporters.first,
      customHeader: ReportersWidget(
        reporters: reporters,
        circleSize: 120,
        displayName: false,
      ),
      onTap: (context) {
        if (skipRules) {
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
        } else {
          Navigator.of(context).pushReplacement(
            RuleScreen.toReporters(reporters).toRoute(context),
          );
        }
      },
    );
  }

  final Color? accentColor;
  final Color? backgroundColor;
  final String? customBtnText;
  final Widget? customHeader;
  final String audioPath;

  final GameProfile user;
  final void Function(BuildContext context) onTap;

  @override
  State<PassThePhone> createState() => _PassThePhoneState();
}

class _PassThePhoneState extends State<PassThePhone> {
  bool _hasPlayedAudio = false;
  bool isFirstRoundofFirstGame = true;
  final BackgroundAudioCubit _cubit = getIt<BackgroundAudioCubit>();

  final _multiRoleString =
      'family/audio/pass_phone_to_the_sidekick_and_reporter.wav';

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
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: FunScaffold(
        minimumPadding: EdgeInsets.zero,
        appBar: FunTopAppBar(
          title: '',
          color:
              widget.backgroundColor ?? widget.user.role!.color.backgroundColor,
          systemNavigationBarColor:
              widget.backgroundColor ?? widget.user.role!.color.backgroundColor,
        ),
        backgroundColor:
            widget.backgroundColor ?? widget.user.role!.color.backgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SvgPicture.asset(
                  'assets/family/images/pass-the-phone.svg',
                  fit: BoxFit.cover,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: widget.customHeader ??
                        GameProfileItem(
                          accentColor: widget.accentColor,
                          profile: widget.user,
                          size: 120,
                          displayName: false,
                          displayRole: false,
                        ),
                  ),
                  const SizedBox(height: 4),
                  FunBackgroundAudioWidget(
                      isVisible: true,
                      audioPath: widget.user.roles.length > 1
                          ? _multiRoleString
                          : widget.audioPath,
                      onPauseOrStop: () {
                        setState(() {
                          _hasPlayedAudio = true;
                        });
                      }),
                  const SizedBox(height: 16),
                  TitleMediumText(
                    widget.user.roles.length > 1
                        ? 'Pass the phone to the\n ${widget.user.roles.first.name} and ${widget.user.roles.last.name} ${widget.user.firstName}'
                        : 'Pass the phone to the\n ${widget.user.role!.name} ${widget.user.firstName}',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: FunButton.secondary(
                      isDisabled: !_hasPlayedAudio && isFirstRoundofFirstGame,
                      onTap: () => widget.onTap.call(context),
                      text: widget.customBtnText ?? 'Continue',
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.reflectAndSharePassThePhoneClicked,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
