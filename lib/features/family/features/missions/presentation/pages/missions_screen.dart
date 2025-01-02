import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/missions/bloc/missions_cubit.dart';
import 'package:givt_app/features/family/features/missions/presentation/models/missions_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_goal_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_goal_card_ui_model.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  final MissionsCubit _cubit = getIt<MissionsCubit>();
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

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
              if (_missions(uiModel).isEmpty)
                BodyMediumText(
                  _selectedIndex == 0
                      ? 'You don’t have any missions currently'
                      : 'You haven’t completed any missions yet',
                  textAlign: TextAlign.center,
                ),
              ...List.generate(
                _missions(uiModel).length,
                (index) {
                  final mission = _missions(uiModel)[index];
                  return FunGoalCard(
                    uiModel: mission,
                    onTap: () {
                      //TODO
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  List<FunGoalCardUIModel> _missions(MissionsUIModel uiModel) =>
      _selectedIndex == 0 ? uiModel.todoMissions : uiModel.completedMissions;
}
