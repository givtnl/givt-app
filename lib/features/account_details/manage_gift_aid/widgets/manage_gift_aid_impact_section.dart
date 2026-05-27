import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/manage_gift_aid/models/manage_gift_aid_card_scenario.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_accordion.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/utils/util.dart';

class ManageGiftAidImpactSection extends StatelessWidget {
  const ManageGiftAidImpactSection({
    required this.scenario,
    required this.displayYear,
    required this.totalGiven,
    required this.extraOrPotential,
    required this.totalImpact,
    required this.isExpanded,
    required this.onHeaderTap,
    required this.countryCode,
    required this.locals,
    super.key,
  });

  final ManageGiftAidCardScenario scenario;
  final String displayYear;
  final double totalGiven;
  final double extraOrPotential;
  final double totalImpact;
  final bool isExpanded;
  final VoidCallback onHeaderTap;
  final String countryCode;
  final AppLocalizations locals;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final symbol = Util.getCurrencySymbol(countryCode: countryCode);
    final country = Country.fromCode(countryCode);

    switch (scenario) {
      case ManageGiftAidCardScenario.tealImpact:
        return FunAccordion(
          leadingIcon: FontAwesomeIcons.handHoldingDollar,
          title: locals.manageGiftAidImpactInTaxYear(displayYear),
          isExpanded: isExpanded,
          state: FunAccordionState.active,
          onHeaderTap: onHeaderTap,
          content: _ImpactRows(
            symbol: symbol,
            country: country,
            row1Label: locals.manageGiftAidYouHaveGiven,
            row1Value: totalGiven,
            row2Label: locals.manageGiftAidExtraAddedWithGiftAid,
            row2Value: extraOrPotential,
            row2PrefixPlus: true,
            totalLabel: locals.manageGiftAidTotalImpact,
            totalValue: totalImpact,
            totalEmphasis: true,
            labelColor: theme.neutral40,
            valueColor: theme.primary40,
            dividerColor: theme.neutral80,
          ),
        );
      case ManageGiftAidCardScenario.orangeOpportunity:
        const headerColor = Color(0xFFD17C30);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: headerColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: headerColor,
                child: InkWell(
                  onTap: onHeaderTap,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.handHoldingDollar,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TitleSmallText(
                            locals.manageGiftAidOrangeCardTitle,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _ImpactRows(
                    symbol: symbol,
                    country: country,
                    row1Label: locals.manageGiftAidGivingInTaxYear(displayYear),
                    row1Value: totalGiven,
                    row2Label: locals.manageGiftAidPotentialBonus,
                    row2Value: extraOrPotential,
                    row2PrefixPlus: true,
                    totalLabel: locals.manageGiftAidPotentialTotalImpact,
                    totalValue: totalImpact,
                    totalEmphasis: true,
                    labelColor: theme.neutral40,
                    valueColor: theme.primary40,
                    dividerColor: theme.neutral80,
                    totalLabelColor: const Color(0xFF6F3900),
                    totalAmountColor: const Color(0xFFB16317),
                  ),
                ),
            ],
          ),
        );
    }
  }
}

class _ImpactRows extends StatelessWidget {
  const _ImpactRows({
    required this.symbol,
    required this.country,
    required this.row1Label,
    required this.row1Value,
    required this.row2Label,
    required this.row2Value,
    required this.row2PrefixPlus,
    required this.totalLabel,
    required this.totalValue,
    required this.totalEmphasis,
    required this.labelColor,
    required this.valueColor,
    required this.dividerColor,
    this.totalLabelColor,
    this.totalAmountColor,
  });

  final String symbol;
  final Country country;
  final String row1Label;
  final double row1Value;
  final String row2Label;
  final double row2Value;
  final bool row2PrefixPlus;
  final String totalLabel;
  final double totalValue;
  final bool totalEmphasis;
  final Color labelColor;
  final Color valueColor;
  final Color dividerColor;
  final Color? totalLabelColor;
  final Color? totalAmountColor;

  String _fmt(double v) => '$symbol${Util.formatNumberComma(v, country)}';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(row1Label, _fmt(row1Value), labelColor, valueColor, false),
        const SizedBox(height: 8),
        _row(
          row2Label,
          '${row2PrefixPlus && row2Value >= 0 ? '+' : ''}${_fmt(row2Value)}',
          labelColor,
          valueColor,
          false,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Divider(height: 1, color: dividerColor),
        ),
        const SizedBox(height: 12),
        _row(
          totalLabel,
          _fmt(totalValue),
          totalLabelColor ?? labelColor,
          totalAmountColor ?? valueColor,
          totalEmphasis,
        ),
      ],
    );
  }

  Widget _row(
    String label,
    String value,
    Color lColor,
    Color vColor,
    bool largeValue,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BodySmallText(
            label,
            color: lColor,
          ),
        ),
        if (largeValue)
          LabelLargeText(value, color: vColor)
        else
          LabelMediumText(value, color: vColor),
      ],
    );
  }
}
