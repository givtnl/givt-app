import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app/features/give/bloc/give/give_bloc.dart';
import 'package:givt_app/features/give/widgets/enter_amount_bottom_sheet.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

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
              _showEnterAmountBottomSheet(
                context,
                state.activeGoal.mediumId,
                state.activeGoal.id,
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
