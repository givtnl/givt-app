import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_day_details.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_overview.dart';

class GenerosityChallenge extends StatelessWidget {
  const GenerosityChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerosityChallengeCubit, GenerosityChallengeState>(
      builder: (BuildContext context, GenerosityChallengeState state) {
        switch (state.status) {
          case GenerosityChallengeStatus.initial:
          case GenerosityChallengeStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case GenerosityChallengeStatus.overview:
            return const GenerosityChallengeOverview();
          case GenerosityChallengeStatus.dayDetails:
            return const GenerosityChallengeDayDetails();
          case GenerosityChallengeStatus.completed:
            //TODO:
            return const Center(child: Text('TODO: Create completed page'));
        }
      },
    );
  }
}
