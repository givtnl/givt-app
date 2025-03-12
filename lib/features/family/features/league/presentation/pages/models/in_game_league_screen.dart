import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/league/bloc/league_cubit.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/league_screen_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/empty_league.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_explanation.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_overview.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class InGameLeagueScreen extends StatefulWidget {
  const InGameLeagueScreen({super.key});

  @override
  State<InGameLeagueScreen> createState() => _InGameLeagueScreenState();
}

class _InGameLeagueScreenState extends State<InGameLeagueScreen> {
  final LeagueCubit _leagueCubit = getIt<LeagueCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _leagueCubit.init();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: EdgeInsets.zero,
      appBar: const FunTopAppBar(
        title: 'League',
      ),
      body: BaseStateConsumer(
        cubit: _leagueCubit,
        onData: (context, uiModel) {
          switch (uiModel) {
            case final ShowLeagueOverview state:
              return LeagueOverview(
                uiModel: state.uiModel,
              );
            case ShowLeagueExplanation():
              return LeagueExplanation(
                onContinuePressed: _leagueCubit.onExplanationContinuePressed,
              );
            case ShowEmptyLeague():
              return const EmptyLeague();
          }
        },
      ),
    );
  }
}
