import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/recurring_donations/create/cubit/step2_set_amount_cubit.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/set_amount_ui_model.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/pages/step3_set_duration_page.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/frequency_dropdown.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/fun_modal_close_flow.dart';
import 'package:givt_app/features/recurring_donations/create/repository/recurring_donation_repository.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/utils.dart';

class Step2SetAmountPage extends StatefulWidget {
  const Step2SetAmountPage({super.key});

  @override
  State<Step2SetAmountPage> createState() => _Step2SetAmountPageState();
}

class _Step2SetAmountPageState extends State<Step2SetAmountPage> {
  final Step2SetAmountCubit _cubit = Step2SetAmountCubit(
    getIt<RecurringDonationRepository>(),
  );
  
  // Add controller for amount field to enable pre-filling
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    // Initialize controller - cubit will handle pre-filling through state
    _amountController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
        // Update controller with current amount from cubit state
        if (uiModel.amount != _amountController.text) {
          _amountController.text = uiModel.amount;
        }
        
        return FunScaffold(
          appBar: FunTopAppBar.white(
            title: context.l10n.recurringDonationsStep2Title,
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FunStepper(currentStep: 1, stepCount: 4),
              const SizedBox(height: 32),
              TitleMediumText(
                context.l10n.recurringDonationsStep2Description,
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
                    eventName: AmplitudeEvents
                        .recurringStep2SetAmountFrequencySelected,
                    eventProperties: {
                      'Frequency': value.name,
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              LabelMediumText(
                context.l10n.recurringDonationsAmountTitle,
                color: FamilyAppTheme.primary40,
              ),
              const SizedBox(height: 8),
              OutlinedTextFormField(
                controller: _amountController,
                hintText: context.l10n.recurringDonationsCreateStep2AmountHint,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    Util.numberInputFieldRegExp(),
                  ),
                ],
                prefixText: Util.getCurrencySymbol(
                  countryCode: context.read<AuthCubit>().state.user.country,
                ),
                onChanged: (value) {
                  _cubit.enterAmount(value);

                  AnalyticsHelper.logEvent(
                    eventName:
                        AmplitudeEvents.recurringStep2SetAmountAmountEntered,
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
                analyticsEvent: AmplitudeEvents.recurringStep2SetAmountContinueClicked.toEvent(
                  parameters: {
                    AnalyticsHelper.amountKey: uiModel.amount,
                    'frequency': uiModel.selectedFrequency?.name ?? '',
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
