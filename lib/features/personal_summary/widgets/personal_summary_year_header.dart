import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/analytics_helper.dart';

/// Secondary top app bar pattern: chevron | centered year | chevron.
class PersonalSummaryYearHeader extends StatelessWidget {
  const PersonalSummaryYearHeader({
    required this.year,
    required this.canGoToPreviousYear,
    required this.canGoToNextYear,
    required this.onPreviousYear,
    required this.onNextYear,
    super.key,
  });

  final int year;
  final bool canGoToPreviousYear;
  final bool canGoToNextYear;
  final VoidCallback onPreviousYear;
  final VoidCallback onNextYear;

  static const _controlSize = 36.0;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return SizedBox(
      height: _controlSize,
      child: Row(
        children: [
          _YearChevron(
            icon: FontAwesomeIcons.chevronLeft,
            enabled: canGoToPreviousYear,
            onTap: () {
              AnalyticsHelper.logEvent(
                eventName: AnalyticsEventName.personalSummaryYearClicked,
                eventProperties: {'direction': 'previous'},
              );
              onPreviousYear();
            },
          ),
          Expanded(
            child: TitleMediumText(
              year.toString(),
              textAlign: TextAlign.center,
              color: theme.primary20,
            ),
          ),
          _YearChevron(
            icon: FontAwesomeIcons.chevronRight,
            enabled: canGoToNextYear,
            onTap: () {
              AnalyticsHelper.logEvent(
                eventName: AnalyticsEventName.personalSummaryYearClicked,
                eventProperties: {'direction': 'next'},
              );
              onNextYear();
            },
          ),
        ],
      ),
    );
  }
}

class _YearChevron extends StatelessWidget {
  const _YearChevron({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final FaIconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return SizedBox(
      width: PersonalSummaryYearHeader._controlSize,
      height: PersonalSummaryYearHeader._controlSize,
      child: Opacity(
        opacity: enabled ? 1 : 0,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: enabled ? onTap : null,
          icon: FaIcon(
            icon,
            size: 20,
            color: theme.primary30,
          ),
        ),
      ),
    );
  }
}
