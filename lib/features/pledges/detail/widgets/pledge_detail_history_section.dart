import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/pledges/detail/models/pledge_history_item.dart';
import 'package:givt_app/features/pledges/shared/pledge_display.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

/// Teal amount color for upcoming history rows (Figma secondary50).
const _upcomingAmountColor = Color(0xFF008586);

class PledgeDetailHistorySection extends StatelessWidget {
  const PledgeDetailHistorySection({
    required this.history,
    required this.countryCode,
    required this.locale,
    super.key,
  });

  final List<PledgeHistoryItem> history;
  final String countryCode;
  final String locale;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSmallText(
          context.l10n.recurringDonationsDetailHistoryTitle,
          color: FunTheme.of(context).primary20,
        ),
        const SizedBox(height: 4),
        ...history.map(
          (item) => _HistoryRow(
            item: item,
            countryCode: countryCode,
            locale: locale,
          ),
        ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.item,
    required this.countryCode,
    required this.locale,
  });

  final PledgeHistoryItem item;
  final String countryCode;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final amountColor =
        item.isUpcoming ? _upcomingAmountColor : FamilyAppTheme.primary50;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: FamilyAppTheme.neutralVariant95),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HistoryIcon(isUpcoming: item.isUpcoming),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.title != null)
                  _HistoryTitleRow(
                    title: item.title!,
                    showUpcoming: item.isUpcoming,
                    upcomingLabel:
                        locals.recurringDonationsDetailStatusUpcoming,
                  ),
                const SizedBox(height: 2),
                ...item.goalLines.map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: BodyMediumText(
                            line.goalName,
                            color: FamilyAppTheme.neutralVariant40,
                          ),
                        ),
                        LabelMediumText(
                          PledgeDisplay.formatAmount(
                            amount: line.amount,
                            countryCode: countryCode,
                          ),
                          color: amountColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
                LabelSmallText(
                  PledgeDisplay.formatHistoryDateLine(
                    item.date,
                    locale,
                    includeTime: !item.isUpcoming,
                  ),
                  color: FamilyAppTheme.neutralVariant50,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTitleRow extends StatelessWidget {
  const _HistoryTitleRow({
    required this.title,
    required this.showUpcoming,
    required this.upcomingLabel,
  });

  final String title;
  final bool showUpcoming;
  final String upcomingLabel;

  @override
  Widget build(BuildContext context) {
    final upcomingTag = FunTag(
      text: upcomingLabel,
      variant: FunTagVariant.secondary,
      iconData: FontAwesomeIcons.arrowsRotate,
      iconSize: 12,
      margin: EdgeInsets.zero,
    );

    return IntrinsicHeight(
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LabelMediumText(
                  title,
                  color: FamilyAppTheme.primary20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showUpcoming) ...[
                const SizedBox(width: 8),
                Opacity(
                  opacity: 0,
                  child: IgnorePointer(child: upcomingTag),
                ),
              ],
            ],
          ),
          if (showUpcoming)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(child: upcomingTag),
            ),
        ],
      ),
    );
  }
}

class _HistoryIcon extends StatelessWidget {
  const _HistoryIcon({required this.isUpcoming});

  final bool isUpcoming;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isUpcoming
            ? FamilyAppTheme.secondary95
            : FamilyAppTheme.primary95,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        isUpcoming ? Icons.more_horiz : Icons.check,
        size: 20,
        color: isUpcoming
            ? FamilyAppTheme.secondary40
            : FamilyAppTheme.primary30,
      ),
    );
  }
}
