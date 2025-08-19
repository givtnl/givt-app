import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/recurring_donations/detail/pages/recurring_donation_detail_page.dart';
import 'package:givt_app/features/recurring_donations/overview/cubit/recurring_donations_overview_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';
import 'package:givt_app/utils/util.dart';

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

  Widget _buildDonationCard(BuildContext context, RecurringDonationWithProgress donationWithProgress) {
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(countryCode: auth.user.country);
    final progress = _getProgressModel(donationWithProgress);

    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: donationWithProgress.donation.collectGroup.orgName,
        description: _buildDescription(donationWithProgress, currency),
        progress: progress,
      ),
      onTap: () => _onDonationTap(context, donationWithProgress),
      useFunProgressbar: true,
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.recurringDonationsClicked,
        parameters: {
          'donation_id': donationWithProgress.donation.id,
          'organisation': donationWithProgress.donation.collectGroup.orgName,
          'amount': donationWithProgress.donation.amountPerTurn.toString(),
          'completed_turns': donationWithProgress.completedTurns.toString(),
          'total_turns': donationWithProgress.donation.endsAfterTurns.toString(),
          'frequency': donationWithProgress.donation.frequency.toString(),
        },
      ),
    );
  }

  String _buildDescription(RecurringDonationWithProgress donationWithProgress, String currency) {
    final amount = donationWithProgress.donation.amountPerTurn.toString();
    final frequency = _getFrequencyText(donationWithProgress.donation.frequency);
    
    // Check if this is a past donation (not active or completed)
    final isPastDonation = donationWithProgress.donation.currentState != RecurringDonationState.active || 
                           donationWithProgress.isCompleted;
    
    final statusText = isPastDonation ? 'Ended' : 'Next up';
    
    // Use end date for past donations, next date for current donations
    final dateToShow = isPastDonation 
        ? donationWithProgress.donation.endDate 
        : donationWithProgress.nextDonationDate;

    return '$frequency $currency$amount · $statusText ${_formatDate(dateToShow)}';
  }

  String _getFrequencyText(int frequency) {
    switch (frequency) {
      case 0:
        return 'Weekly';
      case 1:
        return 'Monthly';
      case 2:
        return 'Quarterly';
      case 3:
        return 'Semi-annually';
      case 4:
        return 'Annually';
      default:
        return 'Recurring';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];

    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;

    return '$day $month $year';
  }

  GoalCardProgressUImodel? _getProgressModel(RecurringDonationWithProgress donationWithProgress) {
    // Don't show progress bar for unlimited donations (endsAfterTurns = 999)
    if (donationWithProgress.donation.endsAfterTurns > 0 && donationWithProgress.donation.endsAfterTurns != 999) {
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

  void _onDonationTap(BuildContext context, RecurringDonationWithProgress donationWithProgress) {
    // Navigate to the detail page
    Navigator.of(context).push(
      RecurringDonationDetailPage(
        recurringDonation: donationWithProgress.donation,
      ).toRoute(context),
    );
  }
}
