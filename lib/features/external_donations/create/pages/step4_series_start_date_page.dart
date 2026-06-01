import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/create/cubit/external_donation_create_cubit.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_flow_step.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_ui_model.dart';
import 'package:givt_app/features/external_donations/create/pages/success_page.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_close_modal.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_preview_helper.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_step_shell.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_past_date_picker.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';

class Step4SeriesStartDatePage extends StatelessWidget {
  const Step4SeriesStartDatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<ExternalDonationCreateCubit>();
    final locals = context.l10n;

    return BaseStateConsumer<ExternalDonationCreateUIModel,
        ExternalDonationCreateCustom>(
      cubit: cubit,
      onCustom: (context, action) {
        switch (action) {
          case NavigateToSuccess():
            Navigator.of(context).pushReplacement(
              const ExternalDonationCreateSuccessPage().toRoute(context),
            );
          case _:
            break;
        }
      },
      onError: (context, error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error ?? locals.somethingWentWrong)),
          );
        });
        return const SizedBox.shrink();
      },
      onData: (context, uiModel) {
        final draft = uiModel.draft;

        return ExternalDonationCreateStepShell(
          title: locals.externalDonationsCreateStartDateLabel,
          currentStep: 2,
          stepCount: uiModel.stepCount,
          onClose: () => const ExternalDonationCreateCloseModal().show(context),
          preview: externalDonationCreatePreviewForStep(
            context,
            uiModel,
            ExternalDonationCreateFlowStep.seriesStartDate,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExternalDonationStepDescription(
                text: locals.externalDonationsCreateStartDateDescriptionWithOrg(
                  draft.organisationName,
                ),
              ),
              const SizedBox(height: 32),
              ExternalDonationPastDatePicker(
                label: locals.externalDonationsCreateStartDateLabel,
                selectedDate: draft.seriesStartDate,
                onDateSelected: cubit.updateSeriesStartDate,
              ),
            ],
          ),
          bottom: FunButton(
            text: locals.externalDonationsCreateConfirmButton,
            isDisabled: !draft.isSeriesStartDateValid,
            isLoading: uiModel.isSubmitting,
            analyticsEvent: AnalyticsEventName.externalDonationsCreateConfirmClicked
                .toEvent(),
            onTap: draft.isSeriesStartDateValid && !uiModel.isSubmitting
                ? cubit.continueFromSeriesStartDate
                : null,
          ),
        );
      },
    );
  }
}
