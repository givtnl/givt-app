import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/give/bloc/give/give_bloc.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_bar.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeGoalTracker extends StatelessWidget {
  const HomeGoalTracker({
    required this.group,
    super.key,
  });
  final ImpactGroup group;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GiveBloc(
            getIt(),
            getIt(),
            getIt(),
            getIt(),
          ),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            Pages.impactGroupDetails.name,
            extra: group,
          );
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 10, left: 10, top: 20),
          decoration: ShapeDecoration(
            color: AppTheme.primary98,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _buildGoalCard(context),
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context) {
    final currentGoal = group.goal;

    return Stack(
      children: [
        const Positioned(
          right: 0,
          top: 38,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              FontAwesomeIcons.arrowRight,
              size: 16,
              color: AppTheme.primary40,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  group.organisation.organisationName ??
                      context.l10n.oopsNoNameForOrganisation,
                  style: GoogleFonts.mulish(
                    textStyle:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  group.type == ImpactGroupType.family
                      ? '${context.l10n.familyGoalPrefix}\$${currentGoal.goalAmount}'
                      : '${context.l10n.goal}: \$${currentGoal.goalAmount} · ${group.amountOfMembers} members',
                  style: GoogleFonts.mulish(
                    textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: GoalProgressBar(goal: currentGoal),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
