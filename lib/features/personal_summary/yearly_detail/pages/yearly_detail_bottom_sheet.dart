import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/yearly_overview/cubit/yearly_overview_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class YearlyDetailBottomSheet extends StatelessWidget {
  const YearlyDetailBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final userCountry = context.read<AuthCubit>().state.user.country;
    final country = Country.fromCode(userCountry);
    final currency = Util.getCurrencySymbol(countryCode: userCountry);
    final yearlyOverviewState = context.watch<YearlyOverviewCubit>().state;
    final isLoading =
        yearlyOverviewState.status == YearlyOverviewStatus.loading;
    return BottomSheetLayout(
      title: Text(yearlyOverviewState.year),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () => context.read<YearlyOverviewCubit>().downloadSummary(),
          child: isLoading
              ? const CircularProgressIndicator()
              : Text(locals.budgetYearlyOverviewDetailReceiveViaMail),
        ),
      ),
      child: BlocListener<YearlyOverviewCubit, YearlyOverviewState>(
        listener: (context, state) {
          if (state.status == YearlyOverviewStatus.error) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.unknownError,
                content: locals.errorContactGivt,
                onConfirm: () => context.pop(),
              ),
            );
          }

          if (state.status == YearlyOverviewStatus.noInternet) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.noInternetConnectionTitle,
                content: locals.noInternet,
                onConfirm: () => context.pop(),
              ),
            );
          }

          if (state.status == YearlyOverviewStatus.summaryDownloaded) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.success,
                content: locals.giftsOverviewSent,
                onConfirm: () => context.pop(),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(
                context: context,
                title: locals.budgetYearlyOverviewDetailThroughGivt,
                amount: locals.budgetYearlyOverviewDetailAmount,
                taxRelief: locals.budgetYearlyOverviewDetailDeductable,
              ),
              Column(
                children: yearlyOverviewState.monthlyByOrganisation
                    .map(
                      (givtDonation) => _buildDonationRow(
                        context: context,
                        currency: currency,
                        organisation: givtDonation.key,
                        amount: Util.formatNumberComma(
                          givtDonation.amount,
                          country,
                        ),
                        isTaxRelief: givtDonation.taxDeductable,
                        isEven: yearlyOverviewState.monthlyByOrganisation
                            .indexOf(givtDonation)
                            .isEven,
                      ),
                    )
                    .toList(),
              ),
              _buildTotalSummary(
                context: context,
                originOfGivts:
                    locals.budgetYearlyOverviewDetailTotalThroughGivt,
                amount: Util.formatNumberComma(
                  yearlyOverviewState.totalWithinGivt,
                  country,
                ),
                taxRelief: Util.formatNumberComma(
                  yearlyOverviewState.taxReliefWithinGivt,
                  country,
                ),
                currency: currency,
              ),
              const SizedBox(
                height: 12,
              ),
              _buildHeader(
                context: context,
                title: locals.budgetYearlyOverviewDetailNotThroughGivt,
                amount: locals.budgetYearlyOverviewDetailAmount,
                taxRelief: locals.budgetYearlyOverviewDetailDeductable,
              ),
              Column(
                children: yearlyOverviewState.externalDonations
                    .map(
                      (nonGivtDonation) => _buildDonationRow(
                        context: context,
                        currency: currency,
                        organisation: nonGivtDonation.key,
                        amount: Util.formatNumberComma(
                          nonGivtDonation.amount,
                          country,
                        ),
                        isTaxRelief: nonGivtDonation.taxDeductable,
                        isEven: yearlyOverviewState.externalDonations
                            .indexOf(nonGivtDonation)
                            .isEven,
                      ),
                    )
                    .toList(),
              ),
              _buildTotalSummary(
                context: context,
                originOfGivts:
                    locals.budgetYearlyOverviewDetailTotalNotThroughGivt,
                amount: Util.formatNumberComma(
                  yearlyOverviewState.totalOutsideGivt,
                  country,
                ),
                taxRelief: Util.formatNumberComma(
                  yearlyOverviewState.taxReliefOutsideGivt,
                  country,
                ),
                currency: currency,
              ),
              const SizedBox(
                height: 12,
              ),
              _buildHeader(
                context: context,
                title: locals.budgetYearlyOverviewGivenTotal,
                amount: '$currency ${Util.formatNumberComma(
                  yearlyOverviewState.totalWithinGivt +
                      yearlyOverviewState.totalOutsideGivt,
                  country,
                )}',
                backgroundColor: AppTheme.givtLightGreen,
              ),
              _buildTipCard(context),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context) {
    final locals = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/givy_money.png',
              height: 60,
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locals.budgetYearlyOverviewDetailTipBold,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    locals.budgetYearlyOverviewDetailTipNormal,
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSummary({
    required BuildContext context,
    required String originOfGivts,
    required String amount,
    required String taxRelief,
    required String currency,
  }) {
    final locals = context.l10n;
    final textTheme = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Colors.white,
        );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      color: AppTheme.givtLightPurple,
      child: Column(
        children: [
          Row(
            children: [
              Text.rich(
                TextSpan(
                  text: locals.budgetYearlyOverviewDetailTotal,
                  style: textTheme.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: ' ',
                      style: textTheme,
                    ),
                    TextSpan(
                      text: originOfGivts,
                      style: textTheme,
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 4,
                child: Text(
                  '$currency $amount',
                  style: textTheme.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                locals.budgetYearlyOverviewDetailTotalDeductable,
                style: textTheme.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              Expanded(child: Container()),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                flex: 2,
                child: Text(
                  '$currency $taxRelief',
                  style: textTheme.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonationRow({
    required BuildContext context,
    required String organisation,
    required String amount,
    required bool isTaxRelief,
    required bool isEven,
    required String currency,
  }) {
    final textTheme = Theme.of(context).textTheme.bodySmall!.copyWith();
    return Container(
      decoration: BoxDecoration(
        color:
            isEven ? AppTheme.givtLightPurple.withOpacity(0.2) : Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              organisation,
              style: textTheme,
            ),
          ),
          Flexible(
            child: Text(
              '$currency $amount',
              style: textTheme.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Icon(
            Icons.check,
            color: isTaxRelief ? AppTheme.givtLightGreen : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String title,
    String amount = '',
    String taxRelief = '',
    Color backgroundColor = AppTheme.givtPurple,
  }) {
    final textTheme = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: textTheme,
          ),
          const Spacer(),
          Text(
            amount,
            style: textTheme,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            taxRelief,
            style: textTheme,
          ),
        ],
      ),
    );
  }
}
