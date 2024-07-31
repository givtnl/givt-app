import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_day_details.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_overview.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/mayor_chat_dialog.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:go_router/go_router.dart';

class GenerosityChallenge extends StatefulWidget {
  const GenerosityChallenge({
    super.key,
  });

  @override
  State<GenerosityChallenge> createState() => _GenerosityChallengeState();
}

class _GenerosityChallengeState extends State<GenerosityChallenge>
    with WidgetsBindingObserver {
  final AppConfig _appConfig = getIt();
  @override
  void initState() {
    super.initState();
    _checkAndLaunchIntro();
  }

  void _checkAndLaunchIntro() {
    if (!GenerosityChallengeHelper.isActivated) {
      Future.delayed(
        Duration.zero,
        () => context.pushReplacementNamed(
          FamilyPages.generosityChallengeIntroduction.name,
          extra: context.read<GenerosityChallengeCubit>(),
        ),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final cubit = context.read<GenerosityChallengeCubit>();
      if (cubit.state.blockAppLifeCycleRefresh) {
        return;
      }
      cubit.loadFromCache();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _onCompleteChallenge() async {
    await context.read<GenerosityChallengeCubit>().completeChallenge();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = context.read<GenerosityChallengeCubit>();
    return BlocConsumer<GenerosityChallengeCubit, GenerosityChallengeState>(
      listener: (context, state) {
        if (state.status == GenerosityChallengeStatus.completed) {
          _onCompleteChallenge();
        } else if (state.showMayor &&
            state.status == GenerosityChallengeStatus.overview) {
          Future.delayed(
            const Duration(milliseconds: 400),
            () => showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return MayorChatDialog(
                  onGoToChat: () {
                    challenge.dismissMayorPopup();
                    context
                      ..pop()
                      ..goNamed(
                        FamilyPages.generosityChallengeChat.name,
                        extra: challenge,
                      );
                  },
                  onDismiss: () {
                    challenge.dismissMayorPopup();
                    context.pop();
                  },
                  isFirstDay: state.availableChatDayIndex == 0,
                );
              },
            ),
          );
        }
      },
      builder: (BuildContext context, GenerosityChallengeState state) {
        switch (state.status) {
          case GenerosityChallengeStatus.initial:
          case GenerosityChallengeStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case GenerosityChallengeStatus.completed:
          case GenerosityChallengeStatus.overview:
            return GenerosityChallengeOverview(isDebug: _appConfig.isTestApp);
          case GenerosityChallengeStatus.dailyAssigmentConfirm:
          case GenerosityChallengeStatus.dailyAssigmentIntro:
            return GenerosityChallengeDayDetails(isDebug: _appConfig.isTestApp);
        }
      },
    );
  }
}
