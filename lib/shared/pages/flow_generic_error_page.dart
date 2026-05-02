import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/pages/flow_generic_error_extra.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

/// Full-screen error state with retry, home, and contact support.
/// Reuse from any flow by pushing with [FlowGenericErrorExtra].
class FlowGenericErrorPage extends StatelessWidget {
  const FlowGenericErrorPage({
    required this.extra,
    super.key,
  });

  final FlowGenericErrorExtra extra;

  static const _metadataFlowKey = 'Flow';
  static const _metadataErrorReasonKey = 'Error reason';

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: extra.screenTitle,
        leading: GivtBackButtonFlat(
          onPressed: () async {
            extra.onTryAgain();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          TitleMediumText(
            extra.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          BodyMediumText(
            extra.message,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FunButton(
            text: locals.tryAgain,
            analyticsEvent:
                AnalyticsEventName.flowGenericErrorTryAgainClicked.toEvent(),
            onTap: extra.onTryAgain,
          ),
          const SizedBox(height: 12),
          FunButton(
            variant: FunButtonVariant.secondary,
            fullBorder: true,
            text: locals.flowGenericErrorContactSupport,
            analyticsEvent: AnalyticsEventName.flowGenericErrorContactSupportClicked
                .toEvent(),
            onTap: () => AboutGivtBottomSheet.show(
              context,
              metadata: {
                _metadataFlowKey: 'Onboarding',
                _metadataErrorReasonKey: extra.errorReason,
              },
            ),
          ),
          const SizedBox(height: 12),
          FunButton(
            variant: FunButtonVariant.secondary,
            fullBorder: true,
            text: locals.flowGenericErrorGoToHome,
            analyticsEvent:
                AnalyticsEventName.flowGenericErrorGoHomeClicked.toEvent(),
            onTap: extra.onGoHome,
          ),
        ],
      ),
    );
  }
}
