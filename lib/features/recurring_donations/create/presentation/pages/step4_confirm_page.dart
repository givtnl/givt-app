import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_text_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon_givy.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/recurring_donations/create/cubit/step4_confirm_cubit.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/confirm_ui_model.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/pages/success_page.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/fun_modal_close_flow.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/summary_row.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart' as overview;
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
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
          case ConfirmAction.navigateToSuccess:
            Navigator.of(context).pushReplacement(
              SuccessPage(model: _cubit.getCurrent()).toRoute(context),
            );
          case ConfirmAction.showErrorBottomSheet:
            _showErrorBottomSheet(context);
          case ConfirmAction.navigateToRecurringDonationsHome:
            // Navigate back to recurring donations home screen
            Navigator.of(context).popUntil((route) => route.isFirst);
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
            leading: const GivtBackButtonFlat(),
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
          body: SingleChildScrollView(
            child: Column(
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
                  analyticsEvent: AmplitudeEvents
                      .recurringStep4ConfirmEditOrganisation
                      .toEvent(),
                  onEdit: _cubit.navigateToOrganization,
                ),
                SummaryRow(
                  icon: FontAwesomeIcons.moneyBillWave,
                  label: context.l10n.recurringDonationsStep4Amount,
                  value: model.amount.isNotEmpty
                      ? '€${model.amount}'
                      : '',
                  analyticsEvent: AmplitudeEvents
                      .recurringStep4ConfirmEditAmount
                      .toEvent(),
                  onEdit: _cubit.navigateToAmount,
                ),
                SummaryRow(
                  icon: FontAwesomeIcons.calendar,
                  label: context.l10n.recurringDonationsStep4Frequency,
                  value: _getFrequencyDisplayText(model.frequency, context),
                  analyticsEvent: AmplitudeEvents
                      .recurringStep4ConfirmEditFrequency
                      .toEvent(),
                  onEdit: _cubit.navigateToFrequency,
                ),
                SummaryRow(
                  icon: FontAwesomeIcons.play,
                  label: context.l10n.recurringDonationsStep4Starts,
                  value: model.startDate != null
                      ? _formatDate(model.startDate!)
                      : '',
                  analyticsEvent: AmplitudeEvents
                      .recurringStep4ConfirmEditStartDate
                      .toEvent(),
                  onEdit: _cubit.navigateToStartDate,
                ),
                SummaryRow(
                  icon: FontAwesomeIcons.stop,
                  label: context.l10n.recurringDonationsStep4Ends,
                  value: endsText,
                  analyticsEvent: AmplitudeEvents
                      .recurringStep4ConfirmEditEndDate
                      .toEvent(),
                  onEdit: _cubit.navigateToEndDate,
                ),
                const SizedBox(height: 32),
                FunButton(
                  text: context.l10n.recurringDonationsStep4ConfirmMyDonation,
                  isLoading: model.isLoading,
                  analyticsEvent: AmplitudeEvents.recurringStep4ConfirmDonation
                      .toEvent(
                        parameters: model.analyticsParams,
                      ),
                  onTap: model.isLoading
                      ? null
                      : _cubit.createRecurringDonation,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorBottomSheet(BuildContext context) {
    FunBottomSheet(
      title: context.l10n.recurringDonationsCreationErrorTitle,
      icon: FunIconGivy.sad(),
      content: Column(
        children: [
          BodyMediumText(
            context.l10n.recurringDonationsCreationErrorDescription,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FunButton(
            text: context.l10n.recurringDonationsCreationErrorChangeAndRetry,
            analyticsEvent: AmplitudeEvents.recurringStep4ErrorChangeDetails
                .toEvent(),
            onTap: () {
              Navigator.of(context).pop(); // Close bottom sheet
            },
          ),
          const SizedBox(height: 16),
          FunTextButton(
            text: context.l10n.cancel,
            analyticsEvent: AmplitudeEvents.recurringStep4ConfirmClose
                .toEvent(),
            onTap: () {
              Navigator.of(context).pop(); // Close bottom sheet
              _cubit.emitCustom(ConfirmAction.navigateToRecurringDonationsHome);
            },
          ),
        ],
      ),
    ).show(context);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _getFrequencyDisplayText(
    overview.Frequency? frequency,
    BuildContext context,
  ) {
    if (frequency == null) return '';

    switch (frequency) {
      case overview.Frequency.weekly:
        return context.l10n.recurringDonationsFrequenciesWeekly;
      case overview.Frequency.monthly:
        return context.l10n.recurringDonationsFrequenciesMonthly;
      case overview.Frequency.quarterly:
        return context.l10n.recurringDonationsFrequenciesQuarterly;
      case overview.Frequency.halfYearly:
        return context.l10n.recurringDonationsFrequenciesHalfYearly;
      case overview.Frequency.yearly:
        return context.l10n.recurringDonationsFrequenciesYearly;
      case overview.Frequency.daily:
      case overview.Frequency.none:
        return '';
    }
  }
}
