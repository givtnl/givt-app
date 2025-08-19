import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/recurring_donations/detail/pages/recurring_donation_detail_page.dart';
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

  final List<RecurringDonation> donations;
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

  Widget _buildDonationCard(BuildContext context, RecurringDonation donation) {
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(countryCode: auth.user.country);
    final progress = _getProgressModel(donation);

    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: donation.collectGroup.orgName,
        description: _buildDescription(donation, currency),
        progress: progress,
      ),
      onTap: () => _onDonationTap(context, donation),
      useFunProgressbar: true,
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.recurringDonationsClicked,
        parameters: {
          'donation_id': donation.id,
          'organisation': donation.collectGroup.orgName,
          'amount': donation.amountPerTurn.toString(),
        },
      ),
    );
  }

  String _buildDescription(RecurringDonation donation, String currency) {
    final amount = donation.amountPerTurn.toString();
    final frequency = _getFrequencyText(donation.frequency);
    final nextDate = donation.getNextDonationDate(DateTime.now());

    return '$frequency $currency$amount · Next up ${_formatDate(nextDate)}';
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

  GoalCardProgressUImodel? _getProgressModel(RecurringDonation donation) {
    // Don't show progress bar for unlimited donations (endsAfterTurns = 999)
    if (donation.endsAfterTurns > 0 && donation.endsAfterTurns != 999) {
      // Calculate progress based on remaining turns
      // This is a simplified calculation - you might want to track actual progress
      final totalTurns = donation.endsAfterTurns;
      const completedTurns = 0; // This would need to come from actual data

      return GoalCardProgressUImodel(
        amount: completedTurns.toDouble(),
        goalAmount: totalTurns,
        totalAmount: totalTurns.toDouble(),
      );
    }
    return null;
  }

  void _onDonationTap(BuildContext context, RecurringDonation donation) {
    // Navigate to the detail page
    Navigator.of(context).push(
      RecurringDonationDetailPage(
        recurringDonation: donation,
      ).toRoute(context),
    );
  }
}
