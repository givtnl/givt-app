import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/yearly_detail/pages/yearly_detail_bottom_sheet.dart';
import 'package:givt_app/features/personal_summary/yearly_overview/cubit/yearly_overview_cubit.dart';
import 'package:givt_app/features/personal_summary/yearly_overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class YearlyOverviewPage extends StatelessWidget {
  const YearlyOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userCountry = context.read<AuthCubit>().state.user.country;
    final country = Country.fromCode(userCountry);
    final currency = Util.getCurrencySymbol(countryCode: userCountry);
    final yearlyOverviewBlocState = context.watch<YearlyOverviewCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text(yearlyOverviewBlocState.year),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GivingGoalSummaryCard(
              currency: currency,
              country: country,
              totalGivenInYear: yearlyOverviewBlocState.totalWithinGivt +
                  yearlyOverviewBlocState.totalOutsideGivt,
              currentYear: yearlyOverviewBlocState.year,
              previousYear:
                  (int.parse(yearlyOverviewBlocState.year) - 1).toString(),
            ),
            _buildDownloadAnnualOverviewButton(
              context: context,
              onTap: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<YearlyOverviewCubit>(),
                  child: const YearlyDetailBottomSheet(),
                ),
              ),
            ),
            SummaryCard(
              totalWithinGivt: yearlyOverviewBlocState.totalWithinGivt,
              totalOutsideGivt: yearlyOverviewBlocState.totalOutsideGivt,
              totalTaxRelief: yearlyOverviewBlocState.totalTaxRelief,
              currency: currency,
              country: country,
            ),
            MonthlySummaryCard(
              currency: currency,
              country: country,
            ),
            PerOrganisationCard(
              currency: currency,
              country: country,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadAnnualOverviewButton({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: AppTheme.givtLightGreen,
        ),
        child: Text(
          context.l10n.budgetYearlyOverviewDownloadButton,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
