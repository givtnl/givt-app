import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/registration/widgets/registered_check_animation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';
import 'package:givt_app/shared/widgets/custom_secondary_border_button.dart';
import 'package:go_router/go_router.dart';

class RegistrationSuccess extends StatelessWidget {
  const RegistrationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'You are registered!\n',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                  children: [
                    TextSpan(
                      text: 'You can now donate.\n\n',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                    ),
                    TextSpan(
                      text: 'Set up your family with Givt4Kids?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              RegisteredCheckAnimation(),
              const Spacer(),
              CustomSecondaryBorderButton(
                title: 'Not right now',
                onPressed: () => context.goNamed(Pages.home.name),
              ),
              CustomGreenElevatedButton(
                title: context.l10n.setUpFamily,
                onPressed: () => context.goNamed(Pages.childrenOverview.name),
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}
