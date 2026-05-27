import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon_givy.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/pages/flow_generic_error_extra.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

/// Full-screen error state with Givy, unified copy, retry, and contact support.
/// Reuse from any flow by pushing with [FlowGenericErrorExtra].
class FlowGenericErrorPage extends StatelessWidget {
  const FlowGenericErrorPage({
    required this.extra,
    super.key,
  });

  final FlowGenericErrorExtra extra;

  static const _metadataFlowKey = 'Flow';
  static const _metadataErrorReasonKey = 'Error reason';
  static const _metadataUserFacingTitleKey = 'User-facing title';
  static const _metadataUserFacingMessageKey = 'User-facing message';

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          extra.onDismiss();
        }
      },
      child: FunScaffold(
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
              locals.flowGenericErrorTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            BodyMediumText(
              locals.flowGenericErrorMessage,
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
              analyticsEvent: AnalyticsEventName
                  .flowGenericErrorContactSupportClicked
                  .toEvent(),
              onTap: () => AboutGivtBottomSheet.show(
                context,
                metadata: _buildSupportMetadata(locals),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _buildSupportMetadata(AppLocalizations locals) {
    return {
      _metadataFlowKey: extra.supportFlow,
      _metadataErrorReasonKey: extra.errorReason,
      _metadataUserFacingTitleKey: locals.flowGenericErrorTitle,
      _metadataUserFacingMessageKey: locals.flowGenericErrorMessage,
      ...extra.supportMetadata,
    };
  }
}
