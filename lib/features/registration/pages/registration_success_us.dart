import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/registration/widgets/registered_check_animation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';
import 'package:givt_app/shared/widgets/custom_secondary_border_button.dart';
import 'package:go_router/go_router.dart';

class RegistrationSuccessUs extends StatelessWidget {
  const RegistrationSuccessUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '${context.l10n.youAreRegistered}\n',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: '${context.l10n.youCanNowDonate}\n\n',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      TextSpan(
                        text: context.l10n.setUpG4kQ,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                RegisteredCheckAnimation(),
                const Spacer(),
                CustomSecondaryBorderButton(
                  title: context.l10n.notRightNow,
                  onPressed: () => context.goNamed(Pages.home.name),
                ),
                CustomGreenElevatedButton(
                  title: context.l10n.setUpFamily,
                  onPressed: () => context.goNamed(Pages.childrenOverview.name),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
