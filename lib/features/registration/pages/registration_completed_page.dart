import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class RegistrationCompletedPage extends StatelessWidget {
  const RegistrationCompletedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunScaffold(
      minimumPadding: EdgeInsets.zero,
      withSafeArea: false,
      floatingActionButton: FunButton(
        onTap: () => context.goNamed(Pages.home.name),
        text: locals.buttonContinue,
        analyticsEvent: AnalyticsEvent(
          AnalyticsEventName.continueClicked,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/givt_registration.gif',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.only(top: 64),
            child: Align(
              alignment: Alignment.topCenter,
              child: TitleLargeText(
                locals.registrationSuccess,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
