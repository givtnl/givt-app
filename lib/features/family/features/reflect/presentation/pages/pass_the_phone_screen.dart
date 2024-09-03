import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';

class PassThePhone extends StatelessWidget {
  const PassThePhone({
    required this.user,
    required this.onTap,
    required this.buttonText,
    super.key,
  });
  final GameProfile user;
  final VoidCallback onTap;
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      border: Border.all(
                        color: user.role!.color,
                        width: 8,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    child: SvgPicture.network(
                      user.pictureURL!,
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TitleMediumText(
                    'Pass the phone to the\n ${user.role!.name} ${user.firstName}',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: FunButton(
                      onTap: onTap,
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
