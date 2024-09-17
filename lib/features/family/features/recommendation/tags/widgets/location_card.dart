import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    required this.location,
    this.isSelected = false,
    this.onPressed,
    super.key,
  });

  final Tag location;
  final void Function()? onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FunTile(
      titleSmall: location.displayText,
      iconPath: location.pictureUrl,
      onTap: onPressed ?? () {},
      isSelected: isSelected,
      borderColor: location.area.borderColor,
      backgroundColor: location.area.backgroundColor,
      textColor: location.area.textColor,
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.locationSelected,
        parameters: {
          'location': location.displayText,
          'isSelected': isSelected,
        },
      ),
    );
  }
}
