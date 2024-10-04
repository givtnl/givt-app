import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/secret_word_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
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
  final scratchKey = GlobalKey<ScratcherState>();
  bool _isScratched = false;
  bool _isSecondWord = false;
  String text = 'Scratch to reveal\nyour secret word';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
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
            const SizedBox(height: 8),
            TitleLargeText(
              text,
              textAlign: TextAlign.center,
              color: FamilyAppTheme.primary30,
            ),
            const Spacer(),
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
                    _isScratched = value > 25;
                    if (_isScratched) {
                      text =
                          'Sneak your secret word\ninto ONE of your answers!';
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
            const Spacer(),
            Visibility(
              visible: !_isSecondWord,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              child: shuffleButton(),
            ),
            const SizedBox(height: 8),
            FunButton(
              isDisabled: !_isScratched,
              onTap: () {
                final sidekick = _cubit.getSidekick();
                Navigator.of(context).pushReplacement(
                  PassThePhone.toSidekick(
                    sidekick,
                    toRules: true,
                  ).toRoute(context),
                );
              },
              text: 'Next',
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.reflectAndShareReadyClicked,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shuffleButton() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _isScratched
            ? () {
                _cubit.onShuffleClicked();
                setState(() {
                  _isScratched = false;
                  _isSecondWord = true;
                  text = 'Scratch to reveal\nyour secret word';
                  scratchKey.currentState?.reset();
                });

                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.reflectAndShareChangeWordClicked,
                );
              }
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LabelLargeText(
              'Change',
              color: _isScratched
                  ? FamilyAppTheme.primary30
                  : FamilyAppTheme.neutralVariant60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                FontAwesomeIcons.shuffle,
                size: 24,
                color: _isScratched
                    ? FamilyAppTheme.primary30
                    : FamilyAppTheme.neutralVariant60,
              ),
            ),
          ],
        ),
      );
}
