import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/background_audio/bloc/background_audio_cubit.dart';
import 'package:givt_app/features/family/features/background_audio/presentation/fun_background_audio_widget.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/secret_word_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:scratcher/widgets.dart';

class RevealSecretWordScreen extends StatefulWidget {
  const RevealSecretWordScreen({
    super.key,
  });

  @override
  State<RevealSecretWordScreen> createState() => _RevealSecretWordScreenState();
}

class _RevealSecretWordScreenState extends State<RevealSecretWordScreen> {
  final SecretWordCubit _cubit = SecretWordCubit(getIt());
  final BackgroundAudioCubit _audioCubit = getIt<BackgroundAudioCubit>();
  final scratchKey = GlobalKey<ScratcherState>();
  bool _isSecretWordVisible = false;
  bool _isSecondWord = false;
  String wordNotVisibleText = 'Scratch to reveal\nyour secret word';
  String wordVisibleText = 'Sneak your secret word\ninto ONE of your answers!';
  late String text;

  @override
  void dispose() {
    _cubit.close();
    _audioCubit.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
    text = wordNotVisibleText;
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      appBar: FunTopAppBar.primary99(
        title: 'Secret Word',
        actions: const [
          LeaveGameButton(),
        ],
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, secretWord) => Column(
          children: [
            const Spacer(),
            const FunBackgroundAudioWidget(
              isVisible: true,
              audioPath: 'family/audio/secret_word_instructions.wav',
            ),
            const SizedBox(height: 8),
            TitleLargeText(
              text,
              textAlign: TextAlign.center,
              color: FamilyAppTheme.primary30,
            ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                secretWordBackground(
                  width: MediaQuery.sizeOf(context).width,
                ),
                Scratcher(
                  key: scratchKey,
                  brushSize: 30,
                  threshold: 50,
                  color: Colors.grey,
                  onChange: (value) => setState(() {
                    _isSecretWordVisible = value > 25;
                    if (_isSecretWordVisible) {
                      text = wordVisibleText;
                    }
                  }),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - 120,
                        height: 100,
                      ),
                      DisplayMediumText(
                        secretWord,
                        textAlign: TextAlign.center,
                        color: FamilyAppTheme.primary30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
            Visibility(
              visible: !_isSecondWord,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              child: shuffleButton(),
            ),
            const SizedBox(height: 8),
            FunButton(
              isDisabled: !_isSecretWordVisible,
              onTap: () {
                final isFirstRound = _cubit.isFirstRound();
                if (isFirstRound) {
                  final sidekick = _cubit.getSidekick();
                  Navigator.of(context).pushReplacement(
                    PassThePhone.toSidekick(
                      sidekick,
                      toRules: true,
                    ).toRoute(context),
                  );
                } else {
                  final reporters = getIt<InterviewCubit>().getReporters();
                  Navigator.of(context).pushReplacement(
                    PassThePhone.toReporters(
                      reporters,
                      skipRules: true,
                    ).toRoute(context),
                  );
                }
              },
              text: 'Next',
              analyticsEvent: AnalyticsEventName.reflectAndShareReadyClicked.toEvent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget shuffleButton() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _isSecretWordVisible
            ? () {
                _cubit.onShuffleClicked();
                setState(() {
                  _isSecretWordVisible = false;
                  _isSecondWord = true;
                  text = wordNotVisibleText;
                  scratchKey.currentState?.reset();
                });

                AnalyticsHelper.logEvent(
                  eventName: AnalyticsEventName.reflectAndShareChangeWordClicked,
                );
              }
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LabelLargeText(
              'Change',
              color: _isSecretWordVisible
                  ? FamilyAppTheme.primary30
                  : FamilyAppTheme.neutralVariant60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                FontAwesomeIcons.shuffle,
                size: 24,
                color: _isSecretWordVisible
                    ? FamilyAppTheme.primary30
                    : FamilyAppTheme.neutralVariant60,
              ),
            ),
          ],
        ),
      );
}
