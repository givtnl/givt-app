import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/missions/bloc/missions_cubit.dart';
import 'package:givt_app/features/family/features/missions/presentation/models/missions_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_goal.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

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
    const options = ['To do', 'Completed'];
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
                options: options,
                selectedIndex: _selectedIndex,
                onPressed: (set) => setState(
                    () => _selectedIndex = set.first == options[0] ? 0 : 1),
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.missionTabsChanged,
                ),
              ),
              const SizedBox(height: 24),
              if (_missions(uiModel).isEmpty)
                FunCard(
                  title: null,
                  content: BodyMediumText.opacityBlack50(
                    _selectedIndex == 0
                        ? "You don't have any missions currently"
                        : "You haven't completed any missions yet",
                    textAlign: TextAlign.center,
                  ),
                  button: null,
                  icon: FunGoal.neutral95(),
                ),
              ...List.generate(
                _missions(uiModel).length,
                (index) {
                  final mission = _missions(uiModel)[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FunMissionCard(
                      uiModel: mission,
                      onTap: mission.namedPage == null ||
                              mission.progress?.amount ==
                                  mission.progress?.goalAmount
                          ? null
                          : () {
                              context.pushNamed(mission.namedPage!);
                            },
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.funMissionCardClicked,
                        parameters: {
                          'mission': mission.title,
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  List<FunMissionCardUIModel> _missions(MissionsUIModel uiModel) =>
      _selectedIndex == 0 ? uiModel.todoMissions : uiModel.completedMissions;
}
