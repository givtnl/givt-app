import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/animations/confetti_helper.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class GivingGoalSetupSuccessPage extends StatefulWidget {
  const GivingGoalSetupSuccessPage({super.key});

  @override
  State<GivingGoalSetupSuccessPage> createState() =>
      _GivingGoalSetupSuccessPageState();
}

class _GivingGoalSetupSuccessPageState
    extends State<GivingGoalSetupSuccessPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ConfettiHelper.show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);
    final extra = GoRouterState.of(context).extra;
    final year = extra is int ? extra : DateTime.now().year;

    return FunScaffold(
      canPop: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/givy_celebration.svg',
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    TitleLargeText(
                      locals.personalSummaryGivingGoalSetupSuccessTitle,
                      textAlign: TextAlign.center,
                      color: theme.primary20,
                    ),
                    const SizedBox(height: 12),
                    BodyMediumText(
                      locals.personalSummaryGivingGoalSetupSuccessMessage(year),
                      textAlign: TextAlign.center,
                      color: theme.primary20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          FunButton(
            text: locals.buttonDone,
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName
                  .personalSummaryGivingGoalSetupSuccessDoneClicked,
            ),
            onTap: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
