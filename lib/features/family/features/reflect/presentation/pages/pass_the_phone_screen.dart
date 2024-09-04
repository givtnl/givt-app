import 'package:flutter/material.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reveal_secret_word.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class PassThePhone extends StatelessWidget {
  const PassThePhone({
    required this.user,
    required this.onTap,
    required this.buttonText,
    super.key,
  });

  factory PassThePhone.toSuperhero(GameProfile user) {
    return PassThePhone(
      user: user,
      onTap: (context) => Navigator.of(context).push(
        const RevealSecretWordScreen().toRoute(context),
      ),
      buttonText: 'Reveal secret word',
    );
  }

  final GameProfile user;
  final void Function(BuildContext context) onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
