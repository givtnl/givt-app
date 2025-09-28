import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/donation_overview/models/donation_overview_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/utils/util.dart';

class MonthlyHeader extends StatelessWidget {
  const MonthlyHeader({
    required this.monthGroup,
    required this.country,
    super.key,
  });

  final MonthlyGroup monthGroup;
  final String country;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = Util.getCurrencySymbol(countryCode: country);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: FamilyAppTheme.primary80, // Light green for monthly header
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleSmallText(
            monthGroup.displayName,
            color: FamilyAppTheme.primary20,
          ),
          TitleSmallText(
            '$currencySymbol ${Util.formatNumberComma(
              monthGroup.totalAmount,
              Country.fromCode(country),
            )}',
            color: FamilyAppTheme.primary20,
          ),
        ],
      ),
    );
  }
}
