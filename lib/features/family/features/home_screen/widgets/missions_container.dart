import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
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
        color: FamilyAppTheme.highlight99,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FamilyAppTheme.neutralVariant95,
          width: 2,
        ),
      ),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
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
      onTap: () => context.pushNamed(FamilyPages.missions.name),
      child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const FaIcon(FontAwesomeIcons.bolt,
                    color: FamilyAppTheme.primary60),
                const SizedBox(height: 12),
                TitleSmallText(
                  missionStats!.missionsToBeCompleted > 0
                      ? 'Missions available'
                      : 'No missions available',
                ),
                const SizedBox(height: 4),
                if (missionStats!.missionsToBeCompleted > 0)
                  BodySmallText(
                    '${missionStats!.missionsToBeCompleted} missions to be completed',
                  )
                else
                  BodySmallText.primary40('Your work here is done'),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: FaIcon(
              FontAwesomeIcons.chevronRight,
              color: FamilyAppTheme.primary40.withOpacity(0.75),
            ),
          )
        ],
      ),
    );
  }
}
