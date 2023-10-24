import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/features/personal_summary/yearly_overview/cubit/yearly_overview_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class PerOrganisationCard extends StatelessWidget {
  const PerOrganisationCard({
    required this.currency,
    required this.country,
    super.key,
  });
  final String currency;
  final Country country;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return CardLayout(
      title: locals.budgetYearlyOverviewPerOrganisation,
      child: BlocBuilder<YearlyOverviewCubit, YearlyOverviewState>(
        builder: (context, state) {
          if (state.status == YearlyOverviewStatus.loading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaddedText(
                locals.budgetSummaryGivt,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildNoGivts(
                isVisible: state.monthlyByOrganisation.isEmpty,
                title: locals.budgetSummaryNoGiftsYearlyOverview,
              ),
              ...state.monthlyByOrganisation.map(
                (givtDonation) => _buildDonationRow(
                  organisation: givtDonation.key,
                  amount: givtDonation.amount,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  color: AppTheme.givtLightGreen,
                ),
              ),
              _buildPaddedText(
                locals.budgetSummaryNotGivt,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildNoGivts(
                isVisible: state.externalDonations.isEmpty,
                title: locals.budgetSummaryNoGiftsYearlyOverview,
              ),
              ...state.externalDonations.map(
                (externalDonation) => _buildDonationRow(
                  organisation: externalDonation.key,
                  amount: externalDonation.amount,
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaddedText(
    String text, {
    TextStyle? textStyle,
  }) =>
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: textStyle,
        ),
      );

  Widget _buildNoGivts({
    required String title,
    bool isVisible = false,
  }) {
    return Visibility(
      visible: isVisible,
      child: _buildPaddedText(
        title,
      ),
    );
  }

  Widget _buildDonationRow({
    required String organisation,
    required double amount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(organisation),
          Text(
            '$currency ${Util.formatNumberComma(
              amount,
              country,
            )}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
