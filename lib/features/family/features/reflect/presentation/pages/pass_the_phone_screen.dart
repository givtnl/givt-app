import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/guess_secret_word_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reveal_secret_word.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class PassThePhone extends StatelessWidget {
  const PassThePhone({
    required this.user,
    required this.onTap,
    required this.buttonText,
    super.key,
  });

  factory PassThePhone.toSuperhero(GameProfile superhero) {
    return PassThePhone(
      user: superhero,
      onTap: (context) => Navigator.of(context).pushReplacement(
        const RevealSecretWordScreen().toRoute(context),
      ),
      buttonText: 'Reveal secret word',
    );
  }

  factory PassThePhone.toSidekick(GameProfile sidekick) {
    return PassThePhone(
      user: sidekick,
      onTap: (context) => Navigator.of(context).pushReplacement(
        const GuessSecretWordScreen().toRoute(context),
      ),
      buttonText: 'Guess secret word',
    );
  }

  final GameProfile user;
  final void Function(BuildContext context) onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: user.role!.color,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    GameProfileItem(
                      profile: user,
                      size: 120,
                      displayName: false,
                    ),
                    const SizedBox(height: 16),
                    TitleMediumText(
                      'Pass the phone to the\n ${user.role!.name} ${user.firstName}',
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: FunButton(
                        onTap: () => onTap.call(context),
                        text: buttonText,
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.reflectAndSharePassThePhoneClicked,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
