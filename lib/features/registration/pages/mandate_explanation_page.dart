import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/features/registration/pages/sign_mandate_page.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';

class MandateExplanationPage extends StatelessWidget {
  const MandateExplanationPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      builder: (_) => const MandateExplanationPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const RegistrationAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                builder: (BuildContext context) =>
                    const TermsAndConditionsDialog(
                  typeOfTerms: TypeOfTerms.slimPayInfo,
                ),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: locals.slimPayInformation,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const WidgetSpan(
                      child: Icon(Icons.info_rounded, size: 16),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Image.asset(
              'assets/images/givy_slim_pay.png',
              height: size.height * 0.2,
            ),
            const Spacer(),
            Text(
              locals.slimPayInformationPart2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SignMandatePage(),
                ),
              ),
              child: Text(locals.next),
            )
          ],
        ),
      ),
    );
  }
}
