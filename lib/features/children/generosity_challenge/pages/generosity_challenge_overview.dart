import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/day_item_placeholder.dart';

class GenerosityChallengeOverview extends StatelessWidget {
  const GenerosityChallengeOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final challenge = context.read<GenerosityChallengeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generosity Mission'),
        // automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: GenerosityChallengeHelper.generosityChallengeDays,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            return DayItemPlaceholder(
              isCompleted: challenge.state.days[index].isCompleted,
              isActive: challenge.state.activeDayIndex == index,
              dayIndex: index,
              onPressed: challenge.activeDay,
            );
          },
        ),
      ),
    );
  }
}
