import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/missions/bloc/missions_cubit.dart';
import 'package:givt_app/features/family/features/missions/presentation/models/missions_ui_model.dart';
import 'package:givt_app/features/family/features/missions/presentation/widgets/missions_dialog.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_goal.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/content/tutorial/fun_tooltip.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({this.showTutorial = false, super.key});

  final bool showTutorial;

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  final MissionsCubit _cubit = getIt<MissionsCubit>();
  final TooltipController _tooltipController = TooltipController();
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init(showTutorial: widget.showTutorial);
  }

  @override
  Widget build(BuildContext context) {
    final options = ['To do', context.l10n.completedKey];
    return OverlayTooltipScaffold(
      overlayColor: FamilyAppTheme.primary50.withValues(alpha: 0.5),
      controller: _tooltipController,
      builder: (context) => FunScaffold(
        appBar: FunTopAppBar(
          leading: const GivtBackButtonFlat(),
          title: context.l10n.missionsTitle,
        ),
        body: BaseStateConsumer(
          cubit: _cubit,
          onData: (context, uiModel) {
            return Column(
              children: [
                FunPrimaryTabs(
                  margin: EdgeInsets.zero,
                  options: options,
                  selectedIndex: _selectedIndex,
                  onPressed: (index) => setState(
                    () => _selectedIndex = index,
                  ),
                  analyticsEvent: AmplitudeEvents.missionTabsChanged.toEvent(),
                ),
                const SizedBox(height: 24),
                if (_missions(uiModel).isEmpty)
                  FunCard(
                    content: BodyMediumText.opacityBlack50(
                      _selectedIndex == 0
                          ? context.l10n.missionsNoMissions
                          : context.l10n.missionsNoCompletedMissions,
                      textAlign: TextAlign.center,
                    ),
                    icon: FunGoal.neutral95(),
                  ),
                ...List.generate(
                  _missions(uiModel).length,
                  (index) {
                    final mission = _missions(uiModel)[index];
                    final title = context.l10n.tutorialMissionTitle;
                    final description = context.l10n.tutorialMissionDescription;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: FunTooltip(
                        tooltipIndex: index,
                        title: title,
                        description: description,
                        labelBottomLeft: '5/6',
                        showButton: false,
                        tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
                        onHighlightedWidgetTap: () {
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.tutorialNextClicked,
                            eventProperties: {
                              'tutorialLabelBottomLeft': '5/6',
                              'tutorialTitle': title,
                              'tutorialDescription': description,
                            },
                          );
                          _tooltipController.dismiss();
                          if (mission.namedPage != null) {
                            context.goNamed(
                              mission.namedPage!,
                              extra: {
                                'fromTutorial': true,
                              },
                            );
                          }
                        },
                        child: FunMissionCard(
                          key: ValueKey(mission.title),
                          uiModel: mission,
                          onTap: mission.namedPage == null ||
                                  mission.progress?.amount ==
                                      mission.progress?.goalAmount
                              ? null
                              : () {
                                  final validValues = [
                                    ...FamilyPages.values.map((e) => e.name),
                                    ...Pages.values.map((e) => e.name),
                                  ];
                                  if (validValues.contains(mission.namedPage)) {
                                    context.goNamed(mission.namedPage!);
                                  } else {
                                    showMissionNotAvailableDialog(
                                      context,
                                    );
                                  }
                                },
                          analyticsEvent: AmplitudeEvents.funMissionCardClicked.toEvent(
                            parameters: {
                              'mission': mission.title,
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
          onCustom: (context, index) => _tooltipController.start(index),
        ),
      ),
    );
  }

  List<FunMissionCardUIModel> _missions(MissionsUIModel uiModel) =>
      _selectedIndex == 0 ? uiModel.todoMissions : uiModel.completedMissions;
}
