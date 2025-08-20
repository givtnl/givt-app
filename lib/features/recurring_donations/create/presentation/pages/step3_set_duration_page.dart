import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_date_picker.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/recurring_donations/create/cubit/step3_set_duration_cubit.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/set_duration_ui_model.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/pages/step4_confirm_page.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/duration_options.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/fun_modal_close_flow.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation_frequency.dart';

class Step3SetDurationPage extends StatefulWidget {
  const Step3SetDurationPage({super.key});

  @override
  State<Step3SetDurationPage> createState() => _Step3SetDurationPageState();
}

class _Step3SetDurationPageState extends State<Step3SetDurationPage> {
  final Step3SetDurationCubit _cubit = getIt<Step3SetDurationCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer<SetDurationUIModel, SetDurationAction>(
      cubit: _cubit,
      onCustom: (context, action) {
        switch (action) {
          case SetDurationAction.navigateToConfirm:
            Navigator.of(context).push(
              const Step4ConfirmPage().toRoute(context),
            );
        }
      },
      onData: (context, uiModel) {
        return FunScaffold(
          appBar: FunTopAppBar.white(
            title: context.l10n.recurringDonationsStep3Title,
            leading: const GivtBackButtonFlat(),
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
          body: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  const FunStepper(currentStep: 2, stepCount: 4),
                  const SizedBox(height: 32),
                  TitleMediumText(
                    context.l10n.recurringDonationsStep3Description,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  LabelMediumText.secondary40(
                    context.l10n.recurringDonationsStartingTitle,
                  ),
                  const SizedBox(height: 8),
                  FunDatePicker(
                    selectedDate: uiModel.startDate,
                    onDateSelected: (date) {
                      _cubit.updateStartDate(date);
                      AnalyticsHelper.logEvent(
                        eventName:
                            AmplitudeEvents.recurringStep3SetDurationStartDate,
                        eventProperties: {'date': date.toIso8601String()},
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  DurationOptions(
                    selectedOption: uiModel.selectedOption,
                    onOptionSelected: (option) {
                      _cubit.updateSelectedOption(option);
                      AnalyticsHelper.logEvent(
                        eventName:
                            AmplitudeEvents.recurringStep3SetDurationOption,
                        eventProperties: {'option': option},
                      );
                    },
                    uiModel: uiModel,
                    frequency:
                        uiModel.frequencyData['frequency']
                            as RecurringDonationFrequency?,
                    onNumberChanged: (number) {
                      _cubit.updateNumberOfDonations(number);
                      AnalyticsHelper.logEvent(
                        eventName:
                            AmplitudeEvents.recurringStep3SetDurationNumber,
                        eventProperties: {'number': number},
                      );
                    },
                    onDateChanged: (date) {
                      _cubit.updateEndDate(date);
                      AnalyticsHelper.logEvent(
                        eventName:
                            AmplitudeEvents.recurringStep3SetDurationEndDate,
                        eventProperties: {'date': date.toIso8601String()},
                      );
                    },
                  ),
                ]),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FunButton(
                      text: context.l10n.buttonContinue,
                      isDisabled: !uiModel.isContinueEnabled,
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.recurringStep3SetDurationContinue,
                        parameters: uiModel.analyticsParams,
                      ),
                      onTap: uiModel.isContinueEnabled
                          ? _cubit.continueToNextStep
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
