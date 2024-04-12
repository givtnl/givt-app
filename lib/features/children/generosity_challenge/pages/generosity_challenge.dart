import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_active_day.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_overview.dart';

class GenerosityChallenge extends StatefulWidget {
  const GenerosityChallenge({super.key});

  @override
  State<GenerosityChallenge> createState() => _GenerosityChallengeState();
}

class _GenerosityChallengeState extends State<GenerosityChallenge>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('executed didChangeAppLifecycleState: $state');
    if (state == AppLifecycleState.resumed) {
      context.read<GenerosityChallengeCubit>().loadFromCache();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
          case GenerosityChallengeStatus.activeDay:
            return const GenerosityChallengeActiveDay();
          case GenerosityChallengeStatus.completed:
            //TODO:
            return const Center(child: Text('TODO: Create completed page'));
        }
      },
    );
  }
}
