import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/guess_secret_word_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/result_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/secret_word_input.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
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
      appBar: const FunTopAppBar(title: 'Guess the word'),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, secretWord) {
          return Center(
            child: FunCard(
              icon: FunIcon.magnifyingGlass(),
              title: 'Type in the secret word',
              content: SecretWordInput(
                amountOfLetters: secretWord.length,
                onChanged: (word) {
                  currentGuessedWord = word;
                },
              ),
              button: FunButton(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    ResultScreen(success: currentGuessedWord == secretWord)
                        .toRoute(context),
                  );
                },
                text: 'Done',
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.reflectAndShareDoneClicked,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
