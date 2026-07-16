import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/datetime/api_date_time.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/pledges/detail/cubit/pledge_detail_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class PledgeDetailSummaryTiles extends StatelessWidget {
  const PledgeDetailSummaryTiles({
    required this.uiModel,
    required this.countryCode,
    required this.locale,
    super.key,
  });

  final PledgeDetailUIModel uiModel;
  final String countryCode;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final endDate = uiModel.group.endDateTime;
    final showTransactionTile = uiModel.totalTransactionCount > 0;

    return Row(
      children: [
        if (showTransactionTile) ...[
          Expanded(
            child: FunTile(
              variant: FunTileVariant.six,
              iconData: FontAwesomeIcons.arrowsRotate,
              assetSize: 32,
              iconPath: '',
              analyticsEvent:
                  AnalyticsEventName.pledgesDetailOpened.toEvent(),
              isPressedDown: true,
              titleBig:
                  '${uiModel.completedTransactionCount} / ${uiModel.totalTransactionCount}',
              subtitle: locals.pledgesDetailTransactionsLabel,
            ),
          ),
        ],
        if (endDate != null) ...[
          if (showTransactionTile) const SizedBox(width: 16),
          Expanded(
            child: FunTile(
              variant: FunTileVariant.six,
              iconData: FontAwesomeIcons.solidCalendar,
              assetSize: 32,
              iconPath: '',
              analyticsEvent:
                  AnalyticsEventName.pledgesDetailOpened.toEvent(),
              isPressedDown: true,
              titleBig: ApiDateTime.formatYMMMd(endDate, locale),
              subtitle: locals.pledgesDetailEndsLabel,
            ),
          ),
        ],
      ],
    );
  }
}
