import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/guess_secret_word_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/summary_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/guess_option_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/guess_the_word_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/family_roles_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/grateful_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/dialogs/confetti_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GuessSecretWordScreen extends StatefulWidget {
  const GuessSecretWordScreen({super.key});

  @override
  State<GuessSecretWordScreen> createState() => _GuessSecretWordScreenState();
}

class _GuessSecretWordScreenState extends State<GuessSecretWordScreen> {
  final GuessSecretWordCubit _cubit = GuessSecretWordCubit(getIt());
  String currentGuessedWord = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      appBar: const FunTopAppBar(
        title: 'Guess the secret word',
        actions: [
          LeaveGameButton(),
        ],
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onCustom: (context, custom) {
          switch (custom) {
            case ShowConfetti():
              ConfettiDialog.show(context);
          }
        },
        onData: (context, uiModel) {
          return Column(
            children: [
              const Spacer(),
              Column(
                children: [
                  TitleMediumText(
                    uiModel.text,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: uiModel.guessOptions.length,
                    itemBuilder: (context, index) {
                      final guessOption = uiModel.guessOptions[index];
                      return FunTile(
                        shrink: true,
                        onTap: () {
                          _cubit.onClickOption(index);
                        },
                        mainAxisAlignment: MainAxisAlignment.center,
                        isPressedDown:
                            guessOption.state == GuessOptionState.wrong,
                        titleBig: guessOption.text,
                        textColor: guessOption.state == GuessOptionState.initial
                            ? FamilyAppTheme.tertiary40
                            : guessOption.state == GuessOptionState.correct
                                ? Colors.green
                                : Colors.red,
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.reflectAndShareGuessOptionClicked,
                          parameters: {
                            'option': guessOption.text,
                          },
                        ),
                        borderColor:
                            guessOption.state == GuessOptionState.initial
                                ? FamilyAppTheme.tertiary80
                                : guessOption.state == GuessOptionState.correct
                                    ? FamilyAppTheme.primary80
                                    : FamilyAppTheme.error80,
                        backgroundColor:
                            guessOption.state == GuessOptionState.initial
                                ? FamilyAppTheme.tertiary98
                                : guessOption.state == GuessOptionState.correct
                                    ? FamilyAppTheme.primary98
                                    : FamilyAppTheme.error98,
                        iconPath: '',
                        hasIcon: false,
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              if (!uiModel.isGameFinished) ...[
                FunButton(
                  isDisabled: !uiModel.areContinuationButtonsEnabled,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      const FamilyRolesScreen().toRoute(context),
                    );
                  },
                  text: 'Shuffle roles',
                  rightIcon: FontAwesomeIcons.arrowRight,
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.reflectAndShareResultShuffleRolesClicked,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              FunButton.secondary(
                isDisabled: !uiModel.areContinuationButtonsEnabled,
                onTap: () {
                  getIt<SummaryCubit>().saveSummary();
                  Navigator.of(context)
                      .push(const GratefulScreen().toRoute(context));
                },
                text: uiModel.isGameFinished ? 'Done' : 'Quit',
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.reflectAndShareQuitClicked,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
