import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/donation_overview/models/donation_overview_uimodel.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/utils/util.dart';

class GiftAidHeader extends StatelessWidget {
  const GiftAidHeader({
    required this.monthGroup,
    required this.country,
    required this.locals,
    super.key,
  });

  final MonthlyGroup monthGroup;
  final String country;
  final AppLocalizations locals;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = Util.getCurrencySymbol(countryCode: country);

    // Calculate gift aid amount for this month
    final giftAidAmount = monthGroup.donations
        .where(
          (d) =>
              d.isGiftAidEnabled &&
              d.taxYear != 0 &&
              d.status.type == DonationStatusType.completed,
        )
        .fold<double>(0, (sum, d) => sum + (d.amount * 0.25));

    // Only show if there's gift aid amount
    if (giftAidAmount <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: FamilyAppTheme.secondary20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TitleSmallText(
              locals.giftOverviewGiftAidBanner(
                "'${monthGroup.year.toString().substring(2)}",
              ),
              color: Colors.white,
            ),
          ),
          TitleSmallText(
            '$currencySymbol ${Util.formatNumberComma(
              giftAidAmount,
              Country.fromCode(country),
            )}',
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
