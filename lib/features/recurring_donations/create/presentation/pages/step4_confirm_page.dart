import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/recurring_donations/create/cubit/step4_confirm_cubit.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/confirm_ui_model.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/pages/success_page.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/fun_modal_close_flow.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/summary_row.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:intl/intl.dart';

class Step4ConfirmPage extends StatefulWidget {
  const Step4ConfirmPage({super.key});

  @override
  State<Step4ConfirmPage> createState() => _Step4ConfirmPageState();
}

class _Step4ConfirmPageState extends State<Step4ConfirmPage> {
  final Step4ConfirmCubit _cubit = getIt<Step4ConfirmCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer<ConfirmUIModel, ConfirmAction>(
      cubit: _cubit,
      onCustom: (context, action) {
        var amountOfPops = 0;
        switch (action) {
          case ConfirmAction.navigateToOrganization:
            amountOfPops = 4;
          case ConfirmAction.navigateToAmount:
            amountOfPops = 2;
          case ConfirmAction.navigateToFrequency:
            amountOfPops = 2;
          case ConfirmAction.navigateToStartDate:
            amountOfPops = 1;
          case ConfirmAction.navigateToEndDate:
            amountOfPops = 1;
          case ConfirmAction.donationConfirmed:
            Navigator.of(context).pushReplacement(
              SuccessPage(model: _cubit.getCurrent()).toRoute(context),
            );
            return;
        }

        for (var i = 0; i < amountOfPops; i++) {
          Navigator.of(context).pop();
        }
      },
      onData: (context, model) {
        var endsText = '';
        if (model.selectedEndOption ==
            RecurringDonationStringKeys.whenIDecide) {
          endsText = context.l10n.recurringDonationsEndsWhenIDecide;
        } else if (model.selectedEndOption ==
                RecurringDonationStringKeys.afterNumberOfDonations &&
            model.numberOfDonations.isNotEmpty) {
          endsText = context.l10n.recurringDonationsEndsAfterXDonations(
            model.numberOfDonations,
          );
        } else if (model.selectedEndOption ==
                RecurringDonationStringKeys.onSpecificDate &&
            model.endDate != null) {
          endsText = _formatDate(model.endDate!);
        }

        return FunScaffold(
          appBar: FunTopAppBar.white(
            title: context.l10n.recurringDonationsStep4Title,
            leading: const BackButton(),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.recurringStep4ConfirmClose,
                  );
                  const FunModalCloseFlow().show(context);
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FunStepper(currentStep: 3, stepCount: 4),
              const SizedBox(height: 32),
              TitleMediumText(
                context.l10n.recurringDonationsStep4Description,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SummaryRow(
                icon: FontAwesomeIcons.building,
                label: context.l10n.recurringDonationsStep4YoullDonateTo,
                value: model.organizationName,
                onEdit: () {
                  AnalyticsHelper.logEvent(
                    eventName:
                        AmplitudeEvents.recurringStep4ConfirmEditOrganisation,
                  );
                  _cubit.navigateToOrganization();
                },
              ),
              SummaryRow(
                icon: FontAwesomeIcons.moneyBillWave,
                label: context.l10n.recurringDonationsStep4Amount,
                value: model.amount.isNotEmpty ? '€${model.amount}' : '',
                onEdit: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.recurringStep4ConfirmEditAmount,
                  );
                  _cubit.navigateToAmount();
                },
              ),
              SummaryRow(
                icon: FontAwesomeIcons.calendar,
                label: context.l10n.recurringDonationsStep4Frequency,
                value: model.frequency,
                onEdit: () {
                  AnalyticsHelper.logEvent(
                    eventName:
                        AmplitudeEvents.recurringStep4ConfirmEditFrequency,
                  );
                  _cubit.navigateToFrequency();
                },
              ),
              SummaryRow(
                icon: FontAwesomeIcons.play,
                label: context.l10n.recurringDonationsStep4Starts,
                value: model.startDate != null
                    ? _formatDate(model.startDate!)
                    : '',
                onEdit: () {
                  AnalyticsHelper.logEvent(
                    eventName:
                        AmplitudeEvents.recurringStep4ConfirmEditStartDate,
                  );
                  _cubit.navigateToStartDate();
                },
              ),
              SummaryRow(
                icon: FontAwesomeIcons.stop,
                label: context.l10n.recurringDonationsStep4Ends,
                value: endsText,
                onEdit: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.recurringStep4ConfirmEditEndDate,
                  );
                  _cubit.navigateToEndDate();
                },
              ),
              const Spacer(),
              FunButton(
                text: context.l10n.recurringDonationsStep4ConfirmMyDonation,
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.recurringStep4ConfirmDonation,
                  parameters: model.analyticsParams,
                ),
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.recurringStep4ConfirmDonation,
                  );
                  _cubit.confirmDonation(
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
