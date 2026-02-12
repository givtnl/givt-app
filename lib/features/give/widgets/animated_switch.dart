import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class AnimatedSwitch extends StatelessWidget {
  const AnimatedSwitch({
    required this.pageIndex,
    required this.onChanged,
    super.key,
  });

  final int pageIndex;
  final dynamic Function(int)? onChanged;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final options = [
      locals.discoverSegmentNow,
      locals.discoverSegmentWho,
    ];
    return FunPrimaryTabs(
      options: options,
      selectedIndex: pageIndex,
      onPressed: (index) => onChanged?.call(index),
      analyticsEvent: AnalyticsEvent(AmplitudeEvents.giveHomeTabsChanged),
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 5),
    );
  }
}
