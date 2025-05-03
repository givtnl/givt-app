import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/recurring_donations/new_flow/cubit/step4_confirm_cubit.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/models/confirm_ui_model.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/widgets/summary_row.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:intl/intl.dart';

class Step4ConfirmPage extends StatelessWidget {
  const Step4ConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Step4ConfirmCubit(
        getIt(),
      )..init(),
      child: const _Step4ConfirmView(),
    );
  }
}

class _Step4ConfirmView extends StatelessWidget {
  const _Step4ConfirmView();

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer<ConfirmUIModel, ConfirmAction>(
      cubit: context.read<Step4ConfirmCubit>(),
      onCustom: (context, action) {
        switch (action) {
          case ConfirmAction.navigateToOrganization:
            Navigator.of(context).popUntil((route) => route.isFirst);
          case ConfirmAction.navigateToAmount:
            Navigator.of(context).pop();
          case ConfirmAction.navigateToFrequency:
            Navigator.of(context).pop();
          case ConfirmAction.navigateToStartDate:
            Navigator.of(context).pop();
          case ConfirmAction.navigateToEndDate:
            Navigator.of(context).pop();
          case ConfirmAction.donationConfirmed:
            Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      onData: (context, model) {
        var endsText = '';
        if (model.selectedEndOption ==
            RecurringDonationStringKeys.whenIDecide) {
          endsText = RecurringDonationStringKeys.whenIDecide;
        } else if (model.selectedEndOption ==
                RecurringDonationStringKeys.afterNumberOfDonations &&
            model.numberOfDonations.isNotEmpty) {
          endsText = RecurringDonationStringKeys.afterNumberOfDonations;
        } else if (model.selectedEndOption ==
                RecurringDonationStringKeys.onSpecificDate &&
            model.endDate != null) {
          endsText = _formatDate(model.endDate!);
        }

        return FunScaffold(
          appBar: FunTopAppBar.white(
            title: 'Confirm',
            leading: const BackButton(),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step4ConfirmClose,
                  );
                  FunModal(
                    icon: FunIcon.xmark(),
                    title: 'Are you sure you want to exit?',
                    subtitle: "If you exit now, your current changes won't be saved.",
                    buttons: [
                      FunButton.destructive(
                        onTap: () {
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.step4ConfirmClose,
                          );
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        text: 'Yes, exit',
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.step4ConfirmClose,
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
              const FunStepper(currentStep: 3, stepCount: 4),
              const SizedBox(height: 32),
              const TitleMediumText(
                'Ready to make a difference?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SummaryRow(
                icon: FontAwesomeIcons.building,
                label: "You'll donate to",
                value: model.organizationName,
                onEdit: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step4ConfirmEditOrganisation,
                  );
                  context.read<Step4ConfirmCubit>().navigateToOrganization();
                },
              ),
              SummaryRow(
                icon: FontAwesomeIcons.moneyBillWave,
                label: 'Amount',
                value: model.amount.isNotEmpty ? '€${model.amount}' : '',
                onEdit: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step4ConfirmEditAmount,
                  );
                  context.read<Step4ConfirmCubit>().navigateToAmount();
                },
              ),
              SummaryRow(
                icon: FontAwesomeIcons.calendar,
                label: 'Frequency',
                value: model.frequency,
                onEdit: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step4ConfirmEditFrequency,
                  );
                  context.read<Step4ConfirmCubit>().navigateToFrequency();
                },
              ),
              SummaryRow(
                icon: FontAwesomeIcons.play,
                label: 'Starts',
                value: model.startDate != null
                    ? _formatDate(model.startDate!)
                    : '',
                onEdit: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step4ConfirmEditStartDate,
                  );
                  context.read<Step4ConfirmCubit>().navigateToStartDate();
                },
              ),
              SummaryRow(
                icon: FontAwesomeIcons.stop,
                label: 'Ends',
                value: endsText,
                onEdit: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step4ConfirmEditEndDate,
                  );
                  context.read<Step4ConfirmCubit>().navigateToEndDate();
                },
              ),
              const Spacer(),
              FunButton(
                text: 'Confirm my donation',
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.step4ConfirmDonation,
                  parameters: model.analyticsParams,
                ),
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.step4ConfirmDonation,
                  );
                  context.read<Step4ConfirmCubit>().confirmDonation(
                        context.read<AuthCubit>().state.user.country,
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
