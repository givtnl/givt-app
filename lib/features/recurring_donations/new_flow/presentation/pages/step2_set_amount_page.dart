import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_dropdown.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/recurring_donations/new_flow/cubit/step2_set_amount_cubit.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/pages/step3_set_duration_page.dart';
import 'package:givt_app/features/recurring_donations/new_flow/repository/recurring_donation_new_flow_repository.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';

class Step2SetAmountPage extends StatefulWidget {
  const Step2SetAmountPage({super.key});

  static const List<String> frequencies = [
    'Weekly',
    'Monthly',
    'Quarterly',
    'Half year',
    'Yearly',
  ];

  @override
  State<Step2SetAmountPage> createState() => _Step2SetAmountPageState();
}

class _Step2SetAmountPageState extends State<Step2SetAmountPage> {
  final Step2SetAmountCubit _cubit =
      Step2SetAmountCubit(getIt<RecurringDonationNewFlowRepository>());

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
            title: 'Set amount',
            leading: const BackButton(),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.cancelClicked,
                  );
                  FunModal(
                    icon: FunIcon.xmark(),
                    title: 'Are you sure you want to exit?',
                    subtitle: "If you exit now, your current changes won't be saved.",
                    buttons: [
                      FunButton.destructive(
                        onTap: () {
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.cancelClicked,
                          );
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        text: 'Yes, exit',
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.cancelClicked,
                        ),
                      ),
                      FunButton.secondary(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        text: 'No, go back',
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.backClicked,
                        ),
                      ),
                    ],
                    closeAction: () {
                      Navigator.of(context).pop();
                    },
                  ).show(context);
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FunStepper(currentStep: 1, stepCount: 4),
              const SizedBox(height: 32),
              const TitleMediumText(
                'How often do you want to give, and how much?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const LabelMediumText(
                'Donation frequency',
                color: FamilyAppTheme.primary40,
              ),
              const SizedBox(height: 8),
              _FrequencyDropdown(
                value: uiModel.selectedFrequency,
                onChanged: (value) {
                  _cubit.selectFrequency(value);
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step2SetAmountFrequencySelected,
                    eventProperties: {
                      AnalyticsHelper.amountKey: value,
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
                    eventName: AmplitudeEvents.step2SetAmountAmountEntered,
                    eventProperties: {
                      AnalyticsHelper.amountKey: value,
                    },
                  );
                },
              ),
              const Spacer(),
              FunButton(
                text: context.l10n.buttonContinue,
                isDisabled: !uiModel.isContinueEnabled,
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.step2SetAmountContinueClicked,
                  parameters: {
                    AnalyticsHelper.amountKey: uiModel.amount,
                    'frequency': uiModel.selectedFrequency ?? '',
                  },
                ),
                onTap: uiModel.isContinueEnabled
                    ? () {
                        _cubit.continueToNextStep();
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FrequencyDropdown extends StatelessWidget {
  const _FrequencyDropdown({
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String> onChanged;

  static const List<String> _options = [
    'Weekly',
    'Monthly',
    'Quarterly',
    'Half year',
    'Yearly',
  ];

  @override
  Widget build(BuildContext context) {
    return FunInputDropdown<String>(
      value: value,
      items: _options,
      hint: const Text('Select one'),
      onChanged: onChanged,
      itemBuilder: (context, option) => Padding(
        padding: const EdgeInsets.only(left: 12),
        child: LabelLargeText(option),
      ),
    );
  }
}
