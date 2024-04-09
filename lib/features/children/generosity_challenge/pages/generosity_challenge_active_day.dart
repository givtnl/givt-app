import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';

class GenerosityChallengeActiveDay extends StatelessWidget {
  const GenerosityChallengeActiveDay({super.key});

  @override
  Widget build(BuildContext context) {
    final challenge = context.read<GenerosityChallengeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Day ${challenge.state.activeDayIndex + 1}'),
        leading: BackButton(
          onPressed: challenge.overview,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35, bottom: 30),
        child: ElevatedButton(
          onPressed: challenge.completeActiveDay,
          child: Text(
            'Complete',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
