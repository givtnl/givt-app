import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/missions/bloc/missions_cubit.dart';
import 'package:givt_app/features/family/features/missions/presentation/models/mission_ui_model.dart';
import 'package:givt_app/features/family/features/missions/presentation/widgets/mission_widget.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/giving_goal_card.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/app_theme.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  final MissionsCubit _cubit = getIt<MissionsCubit>();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        leading: GivtBackButtonFlat(),
        title: 'Missions available',
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, uiModel) {
          return Column(
            children: [
              FunTabs(
                margin: EdgeInsets.zero,
                options: const ['To do', 'Completed'],
                selectedIndex: _selectedIndex,
                onPressed: (index) => setState(() => _selectedIndex = index),
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.missionTabsChanged,
                ),
              ),
              const SizedBox(height: 24),
              MissionWidget(
                uiModel: MissionUIModel(
                  title: 'Mission Bedtime',
                  description: 'Make it a habit',
                  progress: 50,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
