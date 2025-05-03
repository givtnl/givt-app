import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/features/recurring_donations/new_flow/cubit/step1_select_organization_cubit.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/models/select_organization_ui_model.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/pages/step2_set_amount_page.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/widgets/method_button.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/widgets/select_organisation_list.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';

class Step1SelectOrganisationPage extends StatelessWidget {
  const Step1SelectOrganisationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Step1SelectOrganizationCubit(getIt())..init(),
      child: const _Step1SelectOrganisationView(),
    );
  }
}

class _Step1SelectOrganisationView extends StatelessWidget {
  const _Step1SelectOrganisationView();

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer<SelectOrganisationUIModel,
        SelectOrganizationAction>(
      cubit: context.read<Step1SelectOrganizationCubit>(),
      onLoading: (context) => const FunScaffold(
        body: Center(
          child: CustomCircularProgressIndicator(),
        ),
      ),
      onCustom: (context, action) {
        switch (action) {
          case SelectOrganizationAction.navigateToAmount:
            Navigator.of(context).push(
              const Step2SetAmountPage().toRoute(context),
            );
        }
      },
      onData: (context, uiModel) {
        return FunScaffold(
          appBar: FunTopAppBar.white(
            title: 'Select organisation',
            leading: const GivtBackButtonFlat(),
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
              const FunStepper(
                currentStep: 0,
                stepCount: 4,
              ),
              const SizedBox(height: 32),
              const TitleMediumText(
                'Who do you want to give to?',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              MethodButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    SelectOrganisationList(
                      onCollectGroupSelected: (CollectGroup collectGroup) {
                        context
                            .read<Step1SelectOrganizationCubit>()
                            .selectOrganization(collectGroup);
                      },
                    ).toRoute(context),
                  );
                },
                imagePath: 'assets/images/select_list.png',
                title: 'Select from list',
                subtitle: 'Search and select an organisation',
              ),
              const SizedBox(height: 16),
              MethodButton(
                onPressed: () {},
                imagePath: 'assets/images/select_qr_phone_scan.png',
                title: 'QR code',
                subtitle: 'Give by scanning a QR code',
              ),
              const SizedBox(height: 16),
              MethodButton(
                onPressed: () {},
                imagePath: 'assets/images/select_location.png',
                title: 'Location',
                subtitle: 'Give based on your location',
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
