import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/features/recurring_donations/create/cubit/step1_select_organization_cubit.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/select_organization_ui_model.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/pages/select_organisation_list_page.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/pages/step2_set_amount_page.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/fun_modal_close_flow.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/method_button.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class Step1SelectOrganisationPage extends StatefulWidget {
  const Step1SelectOrganisationPage({this.collectGroup, super.key});

  final CollectGroup? collectGroup;

  @override
  State<Step1SelectOrganisationPage> createState() =>
      _Step1SelectOrganisationPageState();
}

class _Step1SelectOrganisationPageState
    extends State<Step1SelectOrganisationPage> {
  final Step1SelectOrganizationCubit _cubit =
      getIt<Step1SelectOrganizationCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = context.read<AuthCubit>().state.user;
    _cubit.init(user, widget.collectGroup);
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer<SelectOrganisationUIModel,
        SelectOrganizationAction>(
      cubit: _cubit,
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
            title: context.l10n.recurringDonationsStep1Title,
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
              const FunStepper(
                currentStep: 0,
                stepCount: 4,
              ),
              const SizedBox(height: 32),
              TitleMediumText(
                context.l10n.recurringDonationsStep1Description,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              MethodButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    SelectOrganisationListPage(
                      onCollectGroupSelected: _cubit.selectOrganization,
                    ).toRoute(context),
                  );
                },
                imagePath: 'assets/images/select_list.png',
                title: context.l10n.recurringDonationsStep1ListTitle,
                subtitle: context.l10n.recurringDonationsStep1ListSubtitle,
              ),
              // const SizedBox(height: 16),
              // MethodButton(
              //   onPressed: () {},
              //   imagePath: 'assets/images/select_qr_phone_scan.png',
              //   title: 'QR code',
              //   subtitle: 'Give by scanning a QR code',
              // ),
              // const SizedBox(height: 16),
              // MethodButton(
              //   onPressed: () {},
              //   imagePath: 'assets/images/select_location.png',
              //   title: 'Location',
              //   subtitle: 'Give based on your location',
              // ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
