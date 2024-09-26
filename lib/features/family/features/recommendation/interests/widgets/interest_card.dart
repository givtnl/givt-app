import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class InterestCard extends StatelessWidget {
  const InterestCard({
    required this.interest,
    required this.onPressed,
    this.isSelected = false,
    super.key,
  });

  final Tag interest;
  final void Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FunTile(
      titleSmall: interest.displayText,
      iconPath: interest.pictureUrl,
      onTap: onPressed,
      isSelected: isSelected,
      borderColor: interest.area.borderColor,
      backgroundColor: interest.area.backgroundColor,
      textColor: interest.area.textColor,
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.interestSelected,
        parameters: {
          'interest': interest.displayText,
          'isSelected': isSelected,
        },
      ),
    );
  }
}
