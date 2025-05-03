import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_date_picker.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/recurring_donations/new_flow/cubit/step3_set_duration_cubit.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/pages/step4_confirm_page.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/widgets/duration_options.dart';
import 'package:givt_app/features/recurring_donations/new_flow/repository/recurring_donation_new_flow_repository.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';

class Step3SetDurationPage extends StatefulWidget {
  const Step3SetDurationPage({super.key});

  @override
  State<Step3SetDurationPage> createState() => _Step3SetDurationPageState();
}

class _Step3SetDurationPageState extends State<Step3SetDurationPage> {
  final Step3SetDurationCubit _cubit = getIt<Step3SetDurationCubit>();
  final RecurringDonationNewFlowRepository _repository =
      getIt<RecurringDonationNewFlowRepository>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.onInit();
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
            title: 'Set duration',
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
              const FunStepper(currentStep: 2, stepCount: 4),
              const SizedBox(height: 32),
              const TitleMediumText(
                'How long would you like to schedule this donation for?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const LabelMediumText('Starting on'),
              const SizedBox(height: 8),
              FunDatePicker(
                selectedDate: uiModel.startDate,
                onDateSelected: (date) {
                  _cubit.updateStartDate(date);
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step3SetDurationStartDate,
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
                    eventName: AmplitudeEvents.step3SetDurationOption,
                    eventProperties: {'option': option},
                  );
                },
                uiModel: uiModel,
                onNumberChanged: (number) {
                  _cubit.updateNumberOfDonations(number);
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step3SetDurationNumber,
                    eventProperties: {'number': number},
                  );
                },
                onDateChanged: (date) {
                  _cubit.updateEndDate(date);
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step3SetDurationEndDate,
                    eventProperties: {'date': date.toIso8601String()},
                  );
                },
              ),
              const Spacer(),
              FunButton(
                text: context.l10n.buttonContinue,
                isDisabled: !uiModel.isContinueEnabled,
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.step3SetDurationContinue,
                  parameters: uiModel.analyticsParams,
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

String _monthName(int month) {
  const months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month];
}
