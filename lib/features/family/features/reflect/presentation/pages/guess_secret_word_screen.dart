import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/guess_secret_word_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/summary_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/guess_the_word_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/family_roles_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/grateful_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
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

  /*
  AnalyticsEvent(
                      AmplitudeEvents.reflectAndShareDoneClicked,
                      parameters: {
                        'success': currentGuessedWord == secretWord,
                        'guessedWord': currentGuessedWord,
                        'secretWord': secretWord,
                      },
                    ),
   */

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
              if (!uiModel.isGameFinished) ...[
                FunButton(
                  isDisabled: !uiModel.areContinuationButtonsEnabled,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      const FamilyRolesScreen().toRoute(context),
                    );
                  },
                  text: 'Next round',
                  rightIcon: FontAwesomeIcons.arrowRight,
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.reflectAndShareResultNextRoundClicked,
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
                text: 'Finish reflecting',
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.reflectAndShareFinishReflectingClicked,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
