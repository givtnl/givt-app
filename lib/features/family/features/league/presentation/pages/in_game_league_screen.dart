import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/league/bloc/in_game_league_cubit.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/in_game_league_screen_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/summary_details_custom.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_explanation.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_overview.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/whos_on_top_of_league.dart';
import 'package:givt_app/features/family/features/reward/presentation/models/reward_uimodel.dart';
import 'package:givt_app/features/family/features/reward/presentation/pages/reward_screen.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/fun_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';
import 'package:givt_app/shared/dialogs/confetti_dialog.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class InGameLeagueScreen extends StatefulWidget {
  const InGameLeagueScreen({super.key});

  @override
  State<InGameLeagueScreen> createState() => _InGameLeagueScreenState();
}

class _InGameLeagueScreenState extends State<InGameLeagueScreen> {
  final InGameLeagueCubit _leagueCubit = getIt<InGameLeagueCubit>();
  bool _isBtnPressedDown = false;
  bool _isBtnLoading = false;

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
      safeAreaBottom: false,
      canPop: false,
      body: BaseStateConsumer(
        cubit: _leagueCubit,
        onCustom: _onCustom,
        onData: (context, uiModel) {
          switch (uiModel) {
            case final ShowLeagueOverview state:
              return LeagueOverview(
                  uiModel: state.uiModel,
                  isPressedDown: _isBtnPressedDown,
                  isBtnLoading: _isBtnLoading,
                  onTap: () {
                    setState(() {
                      _isBtnLoading = true;
                    });
                    _leagueCubit.onLeagueOverviewContinuePressed();
                  });
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

  void _onCustom(BuildContext context, InGameLeagueCustom custom) {
    switch (custom) {
      case ShowConfetti():
        _showConffetti(context);
      case NavigateToProfileSelection():
        _navigateToProfileSelection(context);
      case final ShowInterviewPopup event:
        _showInterviewPopup(
          context,
          event.uiModel,
          useDefaultImage: event.useDefaultImage,
        );
      case NavigateToRewardScreen():
        _navigateToRewardScreen(context, custom.uiModel);
    }
  }

  void _showInterviewPopup(
    BuildContext context,
    FunDialogUIModel uiModel, {
    bool useDefaultImage = true,
  }) {
    FunDialog.show(
      context,
      uiModel: uiModel,
      image: useDefaultImage ? FunIcon.solidComments() : FunIcon.moneyBill(),
      onClickPrimary: () {
        context.pop();
        launchCalendlyUrl();
        _showConffetti(context);
        _navigateToProfileSelection(context);
      },
      onClickSecondary: () {
        context.pop();
        _showConffetti(context);
        _navigateToProfileSelection(context);
      },
    );
  }

  void _showConffetti(BuildContext context) {
    ConfettiDialog.show(context);
  }

  void _navigateToProfileSelection(BuildContext context) {
    setState(() {
      _isBtnLoading = false;
    });
    context.goNamed(
      FamilyPages.profileSelection.name,
    );
  }

  void _navigateToRewardScreen(BuildContext context, RewardUIModel uiModel) {
    Navigator.of(context).push(RewardScreen(
      uiModel: uiModel,
    ).toRoute(context));
  }

  Future<void> launchCalendlyUrl() async {
    const calendlyLink = 'https://calendly.com/andy-765/45min';

    final url = Uri.parse(calendlyLink);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // do nothing, we're probably on a weird platform/ simulator
    }
  }
}
