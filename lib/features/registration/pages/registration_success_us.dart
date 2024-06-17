import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/registration/widgets/registered_check_animation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:go_router/go_router.dart';

class RegistrationSuccessUs extends StatelessWidget {
  const RegistrationSuccessUs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 64),
                Text(
                  'Registration complete',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set up your family and experience generosity together.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                const Spacer(),
                const RegisteredCheckAnimation(),
                const Spacer(),
                CustomGreenElevatedButton(
                  title: context.l10n.setUpFamily,
                  onPressed: () => context.pushNamed(FamilyPages.addMember.name),
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
