import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/recurring_donations/new_flow/cubit/step2_set_amount_cubit.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/pages/step3_set_duration_page.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/widgets/frequency_dropdown.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/widgets/fun_modal_close_flow.dart';
import 'package:givt_app/features/recurring_donations/new_flow/repository/recurring_donation_new_flow_repository.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class Step2SetAmountPage extends StatefulWidget {
  const Step2SetAmountPage({super.key});

  @override
  State<Step2SetAmountPage> createState() => _Step2SetAmountPageState();
}

class _Step2SetAmountPageState extends State<Step2SetAmountPage> {
  final Step2SetAmountCubit _cubit =
      Step2SetAmountCubit(getIt<RecurringDonationNewFlowRepository>());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer<SetAmountUIModel, SetAmountAction>(
      cubit: _cubit,
      onCustom: (context, action) {
        switch (action) {
          case SetAmountAction.navigateToDuration:
            Navigator.of(context).push(
              const Step3SetDurationPage().toRoute(context),
            );
        }
      },
      onData: (context, uiModel) {
        return FunScaffold(
          appBar: FunTopAppBar.white(
            title: 'Set Amount',
            leading: const BackButton(),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.cancelClicked,
                  );
                  const FunModalCloseFlow().show(context);
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FunStepper(currentStep: 1, stepCount: 4),
              const SizedBox(height: 32),
              TitleMediumText(
                context.l10n.recurringDonationsSetAmountTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              LabelMediumText(
                context.l10n.recurringDonationsFrequencyTitle,
                color: FamilyAppTheme.primary40,
              ),
              const SizedBox(height: 8),
              FrequencyDropdown(
                value: uiModel.selectedFrequency,
                onChanged: (value) {
                  _cubit.selectFrequency(value);

                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.recurringStep2SetAmountFrequencySelected,
                    eventProperties: {
                      'Frequency': value,
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              const LabelMediumText(
                'Donation amount',
                color: FamilyAppTheme.primary40,
              ),
              const SizedBox(height: 8),
              OutlinedTextFormField(
                hintText: 'Enter amount',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  _cubit.enterAmount(value);

                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.recurringStep2SetAmountAmountEntered,
                    eventProperties: {
                      'Amount': value,
                    },
                  );
                },
              ),
              const Spacer(),
              FunButton(
                text: context.l10n.buttonContinue,
                isDisabled: !uiModel.isContinueEnabled,
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.recurringStep2SetAmountContinueClicked,
                  parameters: {
                    AnalyticsHelper.amountKey: uiModel.amount,
                    'frequency': uiModel.selectedFrequency ?? '',
                  },
                ),
                onTap: uiModel.isContinueEnabled
                    ? _cubit.continueToNextStep
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
