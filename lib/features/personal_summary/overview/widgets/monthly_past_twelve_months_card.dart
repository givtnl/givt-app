import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';

class MonthlyPastTwelveMonthsCard extends StatelessWidget {
  const MonthlyPastTwelveMonthsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return CardLayout(
      title: locals.budgetSummaryMonth,
      child: BlocBuilder<PersonalSummaryBloc, PersonalSummaryState>(
        builder: (context, state) {
          return SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: state.pastTwelveMonths.map(
                (item) {
                  return MonthlyBarChart(
                    month: item.key,
                    amount: item.amount,
                  );
                },
              ).toList(),
            ),
          );
        },
      ),
    );
  }
}
