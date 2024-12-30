import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        title: 'Missions available',
      ),
      body: Column(
        children: [
          FunTabs(
              options: const ['To do', 'Completed'],
              selectedIndex: _selectedIndex,
              onPressed: (index) => setState(() => _selectedIndex = index),
              analyticsEvent:
                  AnalyticsEvent(AmplitudeEvents.missionTabsChanged))
        ],
      ),
    );
  }
}
