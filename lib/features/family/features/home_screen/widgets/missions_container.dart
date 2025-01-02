import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/mission_stats.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
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
          : FunMissionCard(
              uiModel: FunMissionCardUiModel(
                title: missionStats!.missionsToBeCompleted > 0
                    ? '${missionsText.capitalize()} available'
                    : 'No $missionsText available',
                description: (missionStats!.missionsToBeCompleted > 0)
                    ? '${missionStats!.missionsToBeCompleted} $missionsText to be completed'
                    : 'Your work here is done',
                headerIcon: FontAwesomeIcons.bolt,
              ),
              onTap: () => context.pushNamed(FamilyPages.missions.name),
            ),
    );
  }
}
