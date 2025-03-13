import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/league/bloc/in_game_league_cubit.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/in_game_league_screen_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_explanation.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_overview.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/whos_on_top_of_league.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class InGameLeagueScreen extends StatefulWidget {
  const InGameLeagueScreen({super.key});

  @override
  State<InGameLeagueScreen> createState() => _InGameLeagueScreenState();
}

class _InGameLeagueScreenState extends State<InGameLeagueScreen> {
  final InGameLeagueCubit _leagueCubit = getIt<InGameLeagueCubit>();

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
      appBar: const FunTopAppBar(title: ''),
      body: BaseStateConsumer(
        cubit: _leagueCubit,
        onCustom: (context, custom) => context.goNamed(
            FamilyPages.profileSelection.name), //TODO go to rewards page
        onData: (context, uiModel) {
          switch (uiModel) {
            case final ShowLeagueOverview state:
              return LeagueOverview(
                uiModel: state.uiModel,
                onTap: _leagueCubit.onLeagueOverviewContinuePressed,
              );
            case ShowLeagueExplanation():
              return LeagueExplanation(
                isInGameVersion: true,
                onContinuePressed: _leagueCubit.onExplanationContinuePressed,
              );
            case ShowWhosOnTop():
              return WhosOnTopOfTheLeague(
                onButtonPressed: _leagueCubit.onWhosTopOfLeagueContinuePressed,
              );
          }
        },
      ),
    );
  }
}
