import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/mission_stats.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/l10n/l10n.dart';
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
    final missionAmount = missionStats!.missionsToBeCompleted;

    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: missionAmount == 1
            ? context.l10n.missionsCardTitleSingular
            : context.l10n.missionsCardTitlePlural,
        description: missionAmount == 1
            ? context.l10n.missionsCardDescriptionSingular
            : context.l10n.missionsCardDescriptionPlural(missionAmount),
        headerIcon: FunAvatar.captain(),
      ),
      onTap: () => context.pushNamed(FamilyPages.missions.name),
      analyticsEvent: AnalyticsEventName.funMissionCardClicked.toEvent(
        parameters: {
          'missionsToBeCompleted': missionAmount,
        },
      ),
    );
  }

  FunMissionCard noMissionCard(BuildContext context) {
    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: context.l10n.missionsCardNoMissionsTitle,
        description: context.l10n.missionsCardNoMissionsDescription,
        headerIcon: FunAvatar.captain(),
      ),
      onTap: () => context.pushNamed(FamilyPages.missions.name),
      analyticsEvent: AnalyticsEventName.funMissionCardClicked.toEvent(
        parameters: {
          'missionsToBeCompleted': '0',
        },
      ),
    );
  }
}
