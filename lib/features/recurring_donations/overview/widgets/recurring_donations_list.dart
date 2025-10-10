import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/recurring_donations/detail/pages/recurring_donation_detail_page.dart';
import 'package:givt_app/features/recurring_donations/overview/cubit/recurring_donations_overview_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';
import 'package:givt_app/utils/util.dart';
import 'package:intl/intl.dart';

class RecurringDonationsList extends StatelessWidget {
  const RecurringDonationsList({
    required this.donations,
    required this.isCurrentTab,
    super.key,
  });

  final List<RecurringDonationWithProgress> donations;
  final bool isCurrentTab;

  @override
  Widget build(BuildContext context) {
    if (donations.isEmpty) {
      return const Center(
        child: Text('No donations found'),
      );
    }

    return ListView.separated(
      itemCount: donations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final donation = donations[index];
        return _buildDonationCard(context, donation);
      },
    );
  }

  Widget _buildDonationCard(
    BuildContext context,
    RecurringDonationWithProgress donationWithProgress,
  ) {
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(countryCode: auth.user.country);
    final progress = _getProgressModel(donationWithProgress);

    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: donationWithProgress.donation.collectGroupName,
        description: _buildDescription(donationWithProgress, currency, context),
        progress: progress,
      ),
      onTap: () => _onDonationTap(context, donationWithProgress),
      useFunProgressbar: true,
      analyticsEvent: AmplitudeEvents.recurringDonationCardClicked.toEvent(
        parameters: {
          'donation_id': donationWithProgress.donation.id,
          'organisation': donationWithProgress.donation.collectGroupName,
          'amount': donationWithProgress.donation.amountPerTurn.toString(),
          'completed_turns': donationWithProgress.completedTurns.toString(),
          'total_turns': donationWithProgress.donation.endsAfterTurns
              .toString(),
          'frequency': donationWithProgress.donation.frequency.name,
        },
      ),
    );
  }

  String _buildDescription(
    RecurringDonationWithProgress donationWithProgress,
    String currency,
    BuildContext context,
  ) {
    final amount = donationWithProgress.donation.amountPerTurn.toString();
    final frequency = _getFrequencyText(
      donationWithProgress.donation.frequency,
      context,
    );

    // Check if this is a cancelled donation
    if (donationWithProgress.donation.currentState ==
        RecurringDonationState.cancelled) {
      return '$frequency $currency$amount · ${context.l10n.recurringDonationsCancelled}';
    }

    // Check if this is a past donation (not active or completed)
    final isPastDonation =
        donationWithProgress.donation.currentState !=
            RecurringDonationState.active ||
        donationWithProgress.isCompleted;

    final statusText = isPastDonation
        ? context.l10n.recurringDonationsListStatusEnded
        : context.l10n.recurringDonationsListStatusNextUp;

    // Use end date for past donations, next date for current donations
    final dateToShow = isPastDonation
        ? donationWithProgress.donation.endDate
        : donationWithProgress.nextDonationDate?.toString();

    final dateText = dateToShow != null
        ? _formatDate(DateTime.parse(dateToShow))
        : '';
    return '$frequency $currency$amount · $statusText $dateText';
  }

  String _getFrequencyText(Frequency frequency, BuildContext context) {
    switch (frequency) {
      case Frequency.weekly:
        return context.l10n.recurringDonationsListFrequencyWeekly;
      case Frequency.monthly:
        return context.l10n.recurringDonationsListFrequencyMonthly;
      case Frequency.quarterly:
        return context.l10n.recurringDonationsListFrequencyQuarterly;
      case Frequency.halfYearly:
        return context.l10n.recurringDonationsListFrequencySemiAnnually;
      case Frequency.yearly:
        return context.l10n.recurringDonationsListFrequencyAnnually;
      case Frequency.daily:
      case Frequency.none:
        return context.l10n.recurringDonationsListFrequencyRecurring;
    }
  }

  String _formatDate(DateTime date) {
    // Use localized date formatting
    final formatter = DateFormat.yMMMd();
    return formatter.format(date);
  }

  GoalCardProgressUImodel? _getProgressModel(
    RecurringDonationWithProgress donationWithProgress,
  ) {
    // Don't show progress bar for unlimited donations (endsAfterTurns = 999)
    if (donationWithProgress.donation.endsAfterTurns > 0 &&
        donationWithProgress.donation.endsAfterTurns != 999) {
      // Use pre-calculated progress information from the cubit
      final totalTurns = donationWithProgress.donation.endsAfterTurns;
      final completedTurns = donationWithProgress.completedTurns;

      return GoalCardProgressUImodel(
        amount: completedTurns.toDouble(),
        goalAmount: totalTurns,
        totalAmount: totalTurns.toDouble(),
      );
    }
    return null;
  }

  void _onDonationTap(
    BuildContext context,
    RecurringDonationWithProgress donationWithProgress,
  ) {
    // Navigate to the detail page
    Navigator.of(context).push(
      RecurringDonationDetailPage(
        recurringDonation: donationWithProgress.donation,
      ).toRoute(context),
    );
  }
}
