import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GiveResultLoadingView extends StatelessWidget {
  const GiveResultLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunScaffold(
      canPop: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const Center(child: CustomCircularProgressIndicator()),
          const SizedBox(height: 24),
          TitleMediumText(
            locals.giveResultLoadingTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          BodyMediumText(
            locals.giveResultLoadingMessage,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class GiveResultSuccessView extends StatelessWidget {
  const GiveResultSuccessView({
    required this.onDone,
    super.key,
  });

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunScaffold(
      canPop: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(child: FunIcon.checkmark()),
          const SizedBox(height: 32),
          TitleMediumText(
            locals.giveResultSuccessTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          BodyMediumText(
            locals.giveResultSuccessMessage,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FunButton(
            text: locals.giveResultDone,
            onTap: onDone,
            analyticsEvent: AnalyticsEventName.giveResultSuccessDoneClicked
                .toEvent(),
          ),
        ],
      ),
    );
  }
}

class GiveResultFailedView extends StatelessWidget {
  const GiveResultFailedView({
    required this.onGoHome,
    super.key,
  });

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);
    return FunScaffold(
      canPop: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: FunIconGivy.sad(
              circleColor: theme.error90,
              circleSize: 140,
            ),
          ),
          const SizedBox(height: 32),
          TitleMediumText(
            locals.giveResultFailedTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          BodyMediumText(
            locals.giveResultFailedMessage,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FunButton(
            text: locals.flowGenericErrorGoToHome,
            onTap: onGoHome,
            analyticsEvent: AnalyticsEventName.giveResultFailedGoHomeClicked
                .toEvent(),
          ),
          const SizedBox(height: 12),
          FunButton(
            variant: FunButtonVariant.secondary,
            fullBorder: true,
            text: locals.flowGenericErrorContactSupport,
            analyticsEvent: AnalyticsEventName
                .giveResultFailedContactSupportClicked
                .toEvent(),
            onTap: () => AboutGivtBottomSheet.show(
              context,
              metadata: const {
                'Flow': 'Giving',
                'Error reason': 'donation_failed',
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GiveResultUnknownView extends StatelessWidget {
  const GiveResultUnknownView({
    required this.onGoHome,
    super.key,
  });

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);
    return FunScaffold(
      canPop: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: FunIconGivy.sad(
              circleColor: theme.secondary90,
              circleSize: 140,
            ),
          ),
          const SizedBox(height: 32),
          TitleMediumText(
            locals.giveResultUnknownTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          BodyMediumText(
            locals.giveResultUnknownMessage,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FunButton(
            text: locals.flowGenericErrorGoToHome,
            onTap: onGoHome,
            analyticsEvent: AnalyticsEventName.giveResultUnknownGoHomeClicked
                .toEvent(),
          ),
          const SizedBox(height: 12),
          FunButton(
            variant: FunButtonVariant.secondary,
            fullBorder: true,
            text: locals.flowGenericErrorContactSupport,
            analyticsEvent: AnalyticsEventName
                .giveResultUnknownContactSupportClicked
                .toEvent(),
            onTap: () => AboutGivtBottomSheet.show(
              context,
              metadata: const {
                'Flow': 'Giving',
                'Error reason': 'donation_status_unknown',
              },
            ),
          ),
        ],
      ),
    );
  }
}
