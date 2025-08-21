import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/confirm_ui_model.dart';
import 'package:givt_app/features/recurring_donations/overview/pages/recurring_donations_overview_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/animations/confetti_helper.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({required this.model, super.key});

  final ConfirmUIModel model;

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ConfettiHelper.show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFFFFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Image.asset(
                    'assets/images/givy_gave.png',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TitleLargeText(
              context.l10n.recurringDonationsSuccessTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            BodyMediumText(
              _buildSubtitle(context),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            FunButton(
              text: context.l10n.buttonDone,
              analyticsEvent: AmplitudeEvents.recurringStep4ConfirmDonation.toEvent(
                parameters: widget.model.analyticsParams,
              ),
              onTap: () {
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.recurringStep4ConfirmDonation,
                );
                // Navigate to recurring donations overview and clear the entire navigation stack
                Navigator.of(context).push(
                  const RecurringDonationsOverviewPage().toRoute(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle(BuildContext context) {
    if (widget.model.selectedEndOption ==
            RecurringDonationStringKeys.afterNumberOfDonations &&
        widget.model.numberOfDonations.isNotEmpty) {
      return "For the next ${widget.model.numberOfDonations} months, you'll be helping ${widget.model.organizationName} make an impact";
    }
    if (widget.model.selectedEndOption ==
        RecurringDonationStringKeys.whenIDecide) {
      return "You'll be helping ${widget.model.organizationName} make an impact until you decide to stop.";
    }
    if (widget.model.selectedEndOption ==
            RecurringDonationStringKeys.onSpecificDate &&
        widget.model.endDate != null) {
      return "Until ${_formatDate(widget.model.endDate!)}, you'll be helping ${widget.model.organizationName} make an impact";
    }
    return "You'll be helping ${widget.model.organizationName} make an impact";
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
