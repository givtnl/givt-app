import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/create/cubit/external_donation_create_cubit.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_ui_model.dart';
import 'package:givt_app/features/external_donations/create/pages/organisation_search_page.dart';
import 'package:givt_app/features/external_donations/create/pages/step2_donation_type_page.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_close_modal.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_step_shell.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';

class Step1OrganisationPage extends StatefulWidget {
  const Step1OrganisationPage({super.key});

  @override
  State<Step1OrganisationPage> createState() => _Step1OrganisationPageState();
}

class _Step1OrganisationPageState extends State<Step1OrganisationPage> {
  final ExternalDonationCreateCubit _cubit = getIt<ExternalDonationCreateCubit>();
  late final TextEditingController _organisationController;

  @override
  void initState() {
    super.initState();
    _organisationController = TextEditingController();
    _cubit.init();
  }

  @override
  void dispose() {
    _organisationController.dispose();
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
          case NavigateToDonationType():
            Navigator.of(context).push(
              const Step2DonationTypePage().toRoute(context),
            );
          case _:
            break;
        }
      },
      onData: (context, uiModel) {
        final draft = uiModel.draft;
        if (_organisationController.text != draft.organisationName) {
          _organisationController.text = draft.organisationName;
        }
        return ExternalDonationCreateStepShell(
          title: locals.externalDonationsCreateOrganisationLabel,
          currentStep: 0,
          stepCount: uiModel.stepCount,
          onClose: () => const ExternalDonationCreateCloseModal().show(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExternalDonationStepDescription(
                text: locals.externalDonationsCreateOrganisationDescription,
              ),
              const SizedBox(height: 32),
              FunInput(
                label: locals.externalDonationsCreateOrganisationLabel,
                readOnly: true,
                hintText: locals.externalDonationsCreateOrganisationHint,
                controller: _organisationController,
                onTap: () {
                  Navigator.of(context).push(
                    OrganisationSearchPage(cubit: _cubit).toRoute(context),
                  );
                },
                suffixIcon: Icon(
                  Icons.search,
                  color: FunTheme.of(context).neutral40,
                ),
                analyticsEvent: AnalyticsEventName
                    .externalDonationsCreateOrganisationSearchClicked
                    .toEvent(),
              ),
              if (draft.isCustomOrganisation) ...[
                const SizedBox(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: BodyMediumText(
                    locals.externalDonationsCreateTaxReliefLabel,
                  ),
                  trailing: Switch(
                    value: draft.taxDeductible,
                    activeColor: FunTheme.of(context).primary40,
                    activeTrackColor: FunTheme.of(context).primary80,
                    inactiveThumbColor: FunTheme.of(context).neutralVariant60,
                    inactiveTrackColor: FunTheme.of(context).neutralVariant90,
                    onChanged: _cubit.updateTaxDeductible,
                  ),
                ),
              ],
            ],
          ),
          bottom: FunButton(
            text: locals.buttonContinue,
            isDisabled: !draft.hasOrganisation,
            analyticsEvent: AnalyticsEventName
                .externalDonationsCreateOrganisationContinueClicked
                .toEvent(),
            onTap: draft.hasOrganisation ? _cubit.continueFromOrganisation : null,
          ),
        );
      },
    );
  }
}
