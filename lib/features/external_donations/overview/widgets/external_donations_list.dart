import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/detail/pages/external_donation_detail_page.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_display.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/utils/util.dart';

class ExternalDonationsList extends StatelessWidget {
  const ExternalDonationsList({
    required this.donations,
    this.onDonationUpdated,
    super.key,
  });

  final List<ExternalDonation> donations;
  final VoidCallback? onDonationUpdated;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 98), // inset + button size
      itemCount: donations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildDonationCard(context, donations[index]);
      },
    );
  }

  Widget _buildDonationCard(BuildContext context, ExternalDonation donation) {
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(countryCode: auth.user.country);

    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: donation.description,
        description: _buildDescription(context, donation, currency),
      ),
      onTap: () => _onDonationTap(context, donation),
      analyticsEvent: AnalyticsEventName.externalDonationsCardClicked.toEvent(
        parameters: {
          'donation_id': donation.id,
          'frequency': donation.frequencyString,
          'active': donation.active.toString(),
        },
      ),
    );
  }

  String _buildDescription(
    BuildContext context,
    ExternalDonation donation,
    String currency,
  ) {
    final auth = context.read<AuthCubit>().state;
    final country = Country.fromCode(auth.user.country);
    final amount = Util.formatNumberComma(donation.amount, country);
    final frequency = _frequencyLabel(context, donation.frequency);
    final dateText = ExternalDonationDisplay.formatStartDate(
      donation,
      Util.getLanguageTageFromLocale(context),
    );

    if (donation.frequency == ExternalDonationFrequency.once) {
      return '$currency$amount · $dateText';
    }

    if (!donation.active) {
      return '$frequency $currency$amount · ${context.l10n.externalDonationsListStatusStopped}';
    }

    return '$frequency $currency$amount';
  }

  String _frequencyLabel(
    BuildContext context,
    ExternalDonationFrequency frequency,
  ) {
    return ExternalDonationFrequencyDropdown.frequencyLabel(
      context.l10n,
      frequency,
    );
  }

  Future<void> _onDonationTap(
    BuildContext context,
    ExternalDonation donation,
  ) async {
    final didUpdate = await Navigator.of(context).push(
      ExternalDonationDetailPage(donation: donation).toRoute(context),
    );
    if (didUpdate == true) {
      onDonationUpdated?.call();
    }
  }
}
