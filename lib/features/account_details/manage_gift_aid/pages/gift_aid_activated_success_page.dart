import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class GiftAidActivatedSuccessPage extends StatelessWidget {
  const GiftAidActivatedSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);

    return FunScaffold(
      appBar: const FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: '',
        leading: SizedBox.shrink(),
      ),
      body: Column(
        children: [
          const Spacer(),
          Image.asset(
            'assets/images/givy_giftaid.png',
            width: 160,
            height: 160,
          ),
          const SizedBox(height: 24),
          TitleMediumText(
            locals.giftAidActiveTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          BodyMediumText(
            locals.giftAidActiveMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          BodyMediumText(
            locals.giftAidActiveInfo,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FunButton(
            onTap: () => context.pop(),
            text: locals.buttonDone,
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName.manageGiftAidSuccessDoneClicked,
            ),
          ),
        ],
      ),
    );
  }
}
