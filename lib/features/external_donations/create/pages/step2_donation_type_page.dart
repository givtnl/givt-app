import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/constants/donation_amount_constants.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/external_donations/create/cubit/external_donation_create_cubit.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_flow_step.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_ui_model.dart';
import 'package:givt_app/features/external_donations/create/pages/step4_one_off_date_page.dart';
import 'package:givt_app/features/external_donations/create/pages/step4_series_start_date_page.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_close_modal.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_preview_helper.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_step_shell.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_create_navigation.dart';
import 'package:givt_app/utils/utils.dart';

class Step2DonationTypePage extends StatefulWidget {
  const Step2DonationTypePage({super.key});

  @override
  State<Step2DonationTypePage> createState() => _Step2DonationTypePageState();
}

class _Step2DonationTypePageState extends State<Step2DonationTypePage> {
  final ExternalDonationCreateCubit _cubit = getIt<ExternalDonationCreateCubit>();
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final draft = _cubit.state;
      if (draft is DataState<ExternalDonationCreateUIModel, ExternalDonationCreateCustom> &&
          draft.data.draft.isOneOff == null) {
        _cubit.selectOneOff();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return BaseStateConsumer<ExternalDonationCreateUIModel,
        ExternalDonationCreateCustom>(
      cubit: _cubit,
      onCustom: (context, action) {
        switch (action) {
          case NavigateToOneOffDate():
            Navigator.of(context).push(
              const Step4OneOffDatePage().toCreateFlowRoute(context),
            );
          case NavigateToSeriesStartDate():
            Navigator.of(context).push(
              const Step4SeriesStartDatePage().toCreateFlowRoute(context),
            );
          case _:
            break;
        }
      },
      onData: (context, uiModel) {
        final draft = uiModel.draft;
        if (_amountController.text != draft.amountInput) {
          _amountController.text = draft.amountInput;
        }

        final isRecurring = draft.isOneOff == false;
        final tabIndex = isRecurring ? 1 : 0;

        return ExternalDonationCreateStepShell(
          title: locals.externalDonationsCreateFrequencyLabel,
          currentStep: 1,
          stepCount: uiModel.stepCount,
          onClose: () => const ExternalDonationCreateCloseModal().show(context),
          preview: externalDonationCreatePreviewForStep(
            context,
            uiModel,
            ExternalDonationCreateFlowStep.donationType,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExternalDonationStepDescription(
                  text: locals.externalDonationsCreateDonationTypeDescription,
                ),
                const SizedBox(height: 32),
                FunPrimaryTabs(
                  margin: EdgeInsets.zero,
                  options: [
                    locals.externalDonationsCreateFrequencyOneOff,
                    locals.externalDonationsCreateFrequencyRecurring,
                  ],
                  selectedIndex: tabIndex,
                  onPressed: (index) {
                    if (index == 0) {
                      _cubit.selectOneOff();
                    } else {
                      _cubit.selectRecurring(
                        draft.frequency ?? ExternalDonationFrequency.monthly,
                      );
                    }
                  },
                  analyticsEvent: AnalyticsEventName
                      .externalDonationsCreateFrequencySelected
                      .toEvent(),
                ),
                const SizedBox(height: 24),
                if (isRecurring)
                  ExternalDonationFrequencyDropdown(
                    value: draft.frequency,
                    onChanged: _cubit.selectRecurring,
                  ),
                if (isRecurring) const SizedBox(height: 24),
                FunInput(
                  label: locals.externalDonationsCreateAmountLabel,
                  controller: _amountController,
                  hintText: locals.recurringDonationsCreateStep2AmountHint,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      Util.numberInputFieldRegExp(),
                    ),
                    LengthLimitingTextInputFormatter(
                      DonationAmountConstants.maxIntegerDigits + 3,
                    ),
                  ],
                  prefixText: Util.getCurrencySymbol(
                    countryCode: context.read<AuthCubit>().state.user.country,
                  ),
                  errorText: _amountErrorText(context, draft.amountInput),
                  onChanged: _cubit.updateAmount,
                  analyticsEvent: AnalyticsEventName
                      .externalDonationsCreateAmountEntered
                      .toEvent(),
                ),
              ],
            ),
          ),
          bottom: FunButton(
            text: locals.buttonContinue,
            isDisabled: !draft.isDonationTypeStepValid,
            analyticsEvent: AnalyticsEventName
                .externalDonationsCreateFrequencyContinueClicked
                .toEvent(),
            onTap: draft.isDonationTypeStepValid
                ? _cubit.continueFromDonationType
                : null,
          ),
        );
      },
    );
  }

  String? _amountErrorText(BuildContext context, String amount) {
    if (!DonationAmountValidation.exceedsMaxInputAmount(amount)) {
      return null;
    }
    final country =
        Country.fromCode(context.read<AuthCubit>().state.user.country);
    final formattedMax = Util.formatNumberComma(
      DonationAmountConstants.maxInputAmount,
      country,
    );
    return context.l10n.donationAmountExceedsMaximum(formattedMax);
  }
}
