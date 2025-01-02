import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/mission_stats.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:go_router/go_router.dart';

class MissionsContainer extends StatelessWidget {
  const MissionsContainer(this.missionStats, {super.key});

  final MissionStats? missionStats;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FamilyAppTheme.primary98,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      child:
          missionStats == null ? showLoadingState() : missionsContent(context),
    );
  }

  Widget showLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget missionsContent(BuildContext context) {
    return GestureDetector(
      //onTap: () => context.pushNamed(FamilyPages.missions.name),
      child: Stack(
        children: [
          Column(
            children: [
              const Row(),
              const SizedBox(height: 16),
              const FaIcon(FontAwesomeIcons.bolt,
                  color: FamilyAppTheme.primary20),
              const SizedBox(height: 12),
              TitleSmallText(
                missionStats!.missionsToBeCompleted > 0
                    ? 'Missions available'
                    : 'All missions completed!',
              ),
              const SizedBox(height: 4),
              if (missionStats!.missionsToBeCompleted > 0)
                BodySmallText(
                  '${missionStats!.missionsToBeCompleted} missions to be completed',
                ),
            ],
          ),
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 24, right: 18),
              child: FaIcon(FontAwesomeIcons.chevronRight),
            ),
          )
        ],
      ),
    );
  }
}
