import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/areas.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class CityCard extends StatelessWidget {
  const CityCard({
    required this.cityName,
    required this.stateName,
    this.isSelected = false,
    this.onPressed,
    super.key,
  });

  final void Function()? onPressed;
  final bool isSelected;
  final String cityName;
  final String stateName;

  @override
  Widget build(BuildContext context) {
    return FunTile(
      titleSmall: cityName,
      subtitle: stateName,
      iconPath: 'assets/family/images/city_arrow.svg',
      onTap: onPressed ?? () {},
      isSelected: isSelected,
      borderColor: Areas.primary.borderColor,
      backgroundColor: Areas.primary.backgroundColor,
      textColor: Areas.primary.textColor,
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.citySelected,
        parameters: {
          'city': cityName,
          'state': stateName,
          'isSelected': isSelected,
        },
      ),
    );
  }
}
