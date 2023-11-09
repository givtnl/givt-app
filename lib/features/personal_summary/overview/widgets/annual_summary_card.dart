import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class AnnualSummaryCard extends StatelessWidget {
  const AnnualSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final currency = Util.getCurrencySymbol(countryCode: user.country);
    return CardLayout(
      title: locals.budgetSummaryYear,
      child: BlocBuilder<PersonalSummaryBloc, PersonalSummaryState>(
        builder: (context, state) {
          var referenceValue = state.annualGivts.isEmpty
              ? 0.0
              : state.annualGivts
                  .reduce(
                    (value, element) =>
                        value.amount > element.amount ? value : element,
                  )
                  .amount;
          if (referenceValue < state.givingGoal.yearlyGivingGoal) {
            referenceValue = state.givingGoal.yearlyGivingGoal;
          }
          return Column(
            children: state.annualGivts.map(
              (item) {
                final amount = item.amount +
                    state.externalDonationsYearSum(
                      int.parse(
                        item.key,
                      ),
                    );
                return AnnualBarChart(
                  year: item.key,
                  amount: amount,
                  currency: currency,
                  yearGoal: referenceValue,
                  onTap: () => context.goNamed(
                    Pages.yearlyOverview.name,
                    queryParameters: {
                      'year': item.key,
                    },
                    extra: context.read<PersonalSummaryBloc>(),
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
