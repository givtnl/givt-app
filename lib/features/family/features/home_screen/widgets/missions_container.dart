import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/mission_stats.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';
import 'package:go_router/go_router.dart';

class MissionsContainer extends StatelessWidget {
  const MissionsContainer(this.missionStats, {super.key});

  final MissionStats? missionStats;
  String get missionsText =>
      missionStats?.missionsToBeCompleted == 1 ? 'mission' : 'missions';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: missionStats == null
          ? FunMissionCard.loading()
          : missionStats!.missionsToBeCompleted > 0
              ? missionsAvailableCard(context)
              : noMissionCard(context),
    );
  }

  FunMissionCard missionsAvailableCard(BuildContext context) {
    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: '${missionsText.capitalize()} available',
        description:
            '${missionStats!.missionsToBeCompleted} $missionsText to be completed',
        headerIcon: FunAvatar.captain(),
      ),
      onTap: () => context.pushNamed(FamilyPages.missions.name),
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.funMissionCardClicked,
        parameters: {
          'missionsToBeCompleted': missionStats!.missionsToBeCompleted,
        },
      ),
    );
  }

  FunMissionCard noMissionCard(BuildContext context) {
    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: 'No $missionsText available',
        description: 'Your work here is done',
        headerIcon: FunAvatar.captain(),
      ),
      onTap: () => context.pushNamed(FamilyPages.missions.name),
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.funMissionCardClicked,
        parameters: {
          'missionsToBeCompleted': '0',
        },
      ),
    );
  }
}
