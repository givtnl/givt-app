import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class SuccessDonationPage extends StatelessWidget {
  const SuccessDonationPage({
    required this.organisationName,
    super.key,
  });

  final String organisationName;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunScaffold(
      canPop: false,
      appBar: const FunTopAppBar(
        variant: FunTopAppBarVariant.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: FunIconGivy.hourglass(circleSize: 140),
          ),
          const SizedBox(height: 32),
          TitleMediumText(
            locals.offlineSuccessTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          BodyMediumText(
            locals.offlineSuccessBodyWithOrg(organisationName),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FunButton(
            text: locals.offlineSuccessGotIt,
            onTap: () => context.goNamed(Pages.home.name),
            analyticsEvent: AnalyticsEventName.offlineSuccessGotItTapped
                .toEvent(),
          ),
        ],
      ),
    );
  }
}
