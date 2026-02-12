import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class GiftAidSuccessPage extends StatelessWidget {
  const GiftAidSuccessPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunScaffold(
      canPop: false,
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        leading: const SizedBox.shrink(),
        title: '',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: Image.asset(
              'assets/images/givy_giftaid.png',
              width: 140,
              height: 140,
            ),
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
            onTap: () {
              context.goNamed(Pages.home.name);
            },
            text: context.l10n.buttonDone,
            analyticsEvent: AmplitudeEvents.giftAidRegistrationDoneClicked
                .toEvent(),
          ),
        ],
      ),
    );
  }
}
