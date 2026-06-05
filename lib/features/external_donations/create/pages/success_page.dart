import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/create/cubit/external_donation_create_cubit.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_flow_step.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_ui_model.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_preview_helper.dart';
import 'package:givt_app/features/external_donations/overview/pages/external_donations_overview_page.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/animations/confetti_helper.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class ExternalDonationCreateSuccessPage extends StatefulWidget {
  const ExternalDonationCreateSuccessPage({super.key});

  @override
  State<ExternalDonationCreateSuccessPage> createState() =>
      _ExternalDonationCreateSuccessPageState();
}

class _ExternalDonationCreateSuccessPageState
    extends State<ExternalDonationCreateSuccessPage> {
  final ExternalDonationCreateCubit _cubit =
      getIt<ExternalDonationCreateCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ConfettiHelper.show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);

    return BaseStateConsumer<ExternalDonationCreateUIModel,
        ExternalDonationCreateCustom>(
      cubit: _cubit,
      onData: (context, uiModel) {
        final preview = externalDonationCreatePreviewForStep(
          context,
          uiModel,
          ExternalDonationCreateFlowStep.success,
          showSectionTitle: false,
        );

        return FunScaffold(
          canPop: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TitleLargeText(
                          locals.externalDonationsCreateSuccessHeadline(
                            uiModel.draft.organisationName,
                          ),
                          textAlign: TextAlign.center,
                          color: theme.primary20,
                        ),
                        if (preview != null) ...[
                          const SizedBox(height: 32),
                          preview,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              FunButton(
                text: locals.buttonDone,
                analyticsEvent: AnalyticsEventName
                    .externalDonationsCreateSuccessDoneClicked
                    .toEvent(),
                onTap: () {
                  _cubit.clearDraftAfterSuccess();
                  Navigator.of(context).pushAndRemoveUntil(
                    const ExternalDonationsOverviewPage().toRoute(context),
                    (route) => route.isFirst,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
