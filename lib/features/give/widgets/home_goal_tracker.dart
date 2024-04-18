import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app/features/give/bloc/give/give_bloc.dart';
import 'package:givt_app/features/give/widgets/enter_amount_bottom_sheet.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class HomeGoalTracker extends StatelessWidget {
  const HomeGoalTracker({super.key});

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
      child: BlocBuilder<GoalTrackerCubit, GoalTrackerState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              final map = <String, dynamic>{
                "id": "GUID",
                "status": "Invited", // Invited or Accepted
                "name": "",
                "type": "Family", // or Impact

                // New fields
                // "description":
                //     "Together as a family we want make a difference.",

                "description":
                    "In a small village lived a craftsman Geppetto. One day he decided to make a wooden toy. He said to himself, 'I will make a little boy and call him Pinocchio.'\n\nHe searched everywhere for a good piece of wood. To his good luck, he came upon a piece of pinewood. After examining the wood, he began to carve it. He worked tirelessly for many hours, and finally, his hard work paid off. He carved a beautiful wooden puppet boy who he named Pinocchio. He said, 'I wish Pinocchio were a real boy.'",

                "image": "https://.......jpg",
                "organiser": {
                  "id": "Guid", // Givt user Id
                  "firstName": "String",
                  "lastName": "String",
                  "avatar": "https://..........svg"
                },
                "amountOfMembers": 0,
                "goal": {
                  "creationDate": "Date",
                  "id": "Guid",
                  "mediumId": "Guid",
                  "goal": 999,
                  "amount": 100,
                  "totalAmount": 430,
                  "status": "InProgress", // or Completed
                },
              };

              final fakeGroup = ImpactGroup.fromMap(map);
              context.pushNamed(
                Pages.impactGroupDetails.name,
                extra: fakeGroup,
              );

              // _showEnterAmountBottomSheet(
              //   context,
              //   state.activeGoal.mediumId,
              //   state.activeGoal.id,
              // );
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
              child: state.status == GoalTrackerStatus.activeGoal
                  ? _buildGoalCard()
                  : const SizedBox(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showEnterAmountBottomSheet(
    BuildContext context,
    String nameSpace,
    String goalId,
  ) {
    final giveBloc = context.read<GiveBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: giveBloc,
        child: EnterAmountBottomSheet(
          collectGroupNameSpace: nameSpace,
          goalId: goalId,
        ),
      ),
    );
  }

  Widget _buildGoalCard() {
    return BlocBuilder<GoalTrackerCubit, GoalTrackerState>(
      builder: (context, state) {
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/goal_flag_small.svg',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.yourFamilyGoalKey,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 17,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.organisation.organisationName ??
                          'Oops, did not get a name for the goal.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
