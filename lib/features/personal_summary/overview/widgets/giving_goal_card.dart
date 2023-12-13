import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/personal_summary/giving_goal/pages/setup_giving_goal_bottom_sheet.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class GivingGoalCard extends StatelessWidget {
  const GivingGoalCard({
    required this.amount,
    required this.description,
    required this.amountTextTheme,
    required this.descriptionTextTheme,
    super.key,
  });

  final String amount;
  final String description;
  final TextStyle amountTextTheme;
  final TextStyle descriptionTextTheme;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    amount,
                    style: amountTextTheme,
                  ),
                ),
                Expanded(
                  child: Text(
                    description,
                    style: descriptionTextTheme,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (_) => BlocProvider.value(
                    value: context.read<PersonalSummaryBloc>(),
                    child: const SetupGivingGoalBottomSheet(),
                  ),
                );
                
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.editGivingGoalClicked,
                );
              },
              child: Text(
                locals.budgetSummaryGivingGoalEdit,
                style: descriptionTextTheme.copyWith(
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  color: AppTheme.givtLightPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
