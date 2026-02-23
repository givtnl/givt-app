import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_text_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/registration/cubit/gift_aid_registration_cubit.dart';
import 'package:givt_app/features/registration/pages/gift_aid_skipped_page.dart';
import 'package:givt_app/features/registration/pages/gift_aid_success_page.dart';
import 'package:givt_app/features/registration/widgets/about_gift_aid_bottom_sheet.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class GiftAidRegistrationPage extends StatefulWidget {
  const GiftAidRegistrationPage({
    required this.cubit,
    super.key,
  });

  final GiftAidRegistrationCubit cubit;

  @override
  State<GiftAidRegistrationPage> createState() =>
      _GiftAidRegistrationPageState();
}

class _GiftAidRegistrationPageState extends State<GiftAidRegistrationPage> {
  bool _exampleExpanded = true;

  GiftAidRegistrationCubit get _cubit => widget.cubit;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: _handleCustom,
      onData: (context, uiModel) {
        final isCheckboxChecked = uiModel.isCheckboxChecked;

        return FunScaffold(
          canPop: false,
          appBar: FunTopAppBar(
          variant: FunTopAppBarVariant.white,
            title: locals.giftAidYourDonationsTitle,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodySmallText(
                locals.giftAidShortExplanation,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),
              FunAccordion(
                leadingIcon: FontAwesomeIcons.handHoldingDollar,
                title: locals.giftAidExampleTitle,
                content: BodySmallText(locals.giftAidExampleText),
                isExpanded: _exampleExpanded,
                state: _exampleExpanded
                    ? FunAccordionState.active
                    : FunAccordionState.collapsed,
                onHeaderTap: () {
                  setState(() {
                    _exampleExpanded = !_exampleExpanded;
                  });
                },
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  AnalyticsHelper.logEvent(
                    eventName:
                        AmplitudeEvents.giftAidRegistrationLearnMoreClicked,
                  );
                  AboutGiftAidBottomSheet.show(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BodySmallText(
                      locals.giftAidLearnMore,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _buildDeclarationSection(context, isCheckboxChecked),
              const SizedBox(height: 16),
              FunButton(
                onTap: isCheckboxChecked ? _cubit.activateForThisTaxYear : null,
                isDisabled: !isCheckboxChecked,
                text: locals.giftAidActivateButton,
                analyticsEvent: AmplitudeEvents
                    .giftAidRegistrationActivateClicked
                    .toEvent(),
              ),
              const SizedBox(height: 8),
              FunTextButton.medium(
                onTap: _cubit.skipForNow,
                text: locals.giftAidSetUpLaterButton,
                analyticsEvent: AmplitudeEvents
                    .giftAidRegistrationSetUpLaterClicked
                    .toEvent(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeclarationSection(
    BuildContext context,
    bool isChecked,
  ) {
    final locals = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            if (value == null) return;
            _cubit.onCheckboxChanged(value);
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodySmallText(
                locals.giftAidDeclarationText,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleCustom(
    BuildContext context,
    GiftAidRegistrationCustom custom,
  ) {
    switch (custom) {
      case GiftAidRegistrationActivated():
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const GiftAidSuccessPage(),
          ),
        );
      case GiftAidRegistrationSkipped():
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const GiftAidSkippedPage(),
          ),
        );
    }
  }
}
