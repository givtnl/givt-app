import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/in_game_league_screen.dart';
import 'package:givt_app/features/family/features/reflect/bloc/summary_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/summary_details.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/summary_details_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/goal_progress_screen.dart';
import 'package:givt_app/features/family/helpers/helpers.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_tag.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/dialogs/confetti_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _cubit = getIt<SummaryCubit>();
  bool pressDown = false;
  bool _isDoneBtnLoading = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: FunScaffold(
        minimumPadding: EdgeInsets.zero,
        safeAreaBottom: false,
        canPop: false,
        body: BaseStateConsumer(
          cubit: _cubit,
          onCustom: _onCustom,
          onData: (context, details) {
            return LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          FunTag.purple(
                            text: DateTime.now().formattedFullMonth,
                          ),
                          const SizedBox(height: 16),
                          const TitleLargeText('Great job Family!'),
                          const Spacer(),
                          if (details.players.isNotEmpty)
                            AvatarBar(
                              circleSize: 54,
                              uiModel: AvatarBarUIModel(
                                avatarUIModels: [
                                  for (var i = 0;
                                      i < details.players.length;
                                      i++)
                                    AvatarUIModel(
                                      avatarUrl: details.players[i].pictureURL,
                                      text: details.players[i].firstName,
                                    ),
                                ],
                              ),
                              onAvatarTapped: (i) {},
                            ),

                          // stats button
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              bottom: 24,
                            ),
                            child: getTileStats(details),
                          ),
                          const Spacer(),
                          // Bottom button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: getFunButton(details),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget getTileStats(SummaryDetails details) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: FunTile.green(
                      titleBig: details.minutesPlayed == 1
                          ? '1 minute family time'
                          : '${details.minutesPlayed} minutes family time',
                      iconData: FontAwesomeIcons.solidClock,
                      assetSize: 32,
                      isPressedDown: true,
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents
                            .familyReflectSummaryMinutesPlayedClicked,
                      ),
                    ),
                  ),
                  if (details.xpEarnedForTime != null)
                    Align(
                      alignment: Alignment.topCenter,
                      child: FunTag.xp(details.xpEarnedForTime!),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: FunTile.red(
                      titleBig: details.generousDeeds == 1
                          ? '1 generous deed'
                          : '${details.generousDeeds} generous deeds',
                      iconData: FontAwesomeIcons.solidHeart,
                      assetSize: 32,
                      isPressedDown: true,
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents
                            .familyReflectSummaryGenerousDeedsClicked,
                      ),
                    ),
                  ),
                  if (details.xpEarnedForDeeds != null)
                    Align(
                      alignment: Alignment.topCenter,
                      child: FunTag.xp(details.xpEarnedForDeeds!),
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 24,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: FunTile.gold(
              titleBig: '${details.totalXp} XP\ntotal',
              iconData: FontAwesomeIcons.bolt,
              assetSize: 32,
              isPressedDown: true,
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.familyReflectSummaryXpClicked,
              ),
            ),
          ),
        ),
      ],
    );
  }

  FunButton getFunButton(SummaryDetails details) {
    final analyticEvent = AnalyticsEvent(
      AmplitudeEvents.familyReflectSummaryClaimXp,
    );

    return FunButton(
      isLoading: _isDoneBtnLoading,
      onTap: _onTapDoneBtn,
      isPressedDown: pressDown,
      text: 'Claim XP',
      analyticsEvent: analyticEvent,
    );
  }

  void _onCustom(BuildContext context, SummaryDetailsCustom custom) {
    switch (custom) {
      case ShowConfetti():
        _showConffetti(context);
      case NavigateToInGameLeague():
        _navigateToInGameLeague(context);
      case NavigateToGoalProgressUpdate():
        _navigateToGoalProgressUpdate(context);
    }
  }

  void _showConffetti(BuildContext context) {
    setState(() {
      pressDown = true;
    });
    ConfettiDialog.show(context);
  }

  void _navigateToInGameLeague(BuildContext context) {
    setState(() {
      _isDoneBtnLoading = false;
    });
    Navigator.of(context).push(const InGameLeagueScreen().toRoute(context));
  }

  void _navigateToGoalProgressUpdate(BuildContext context) {
    setState(() {
      _isDoneBtnLoading = false;
    });

    Navigator.of(context).push(const GoalProgressScreen().toRoute(context));
  }

  void _onTapDoneBtn() {
    setState(() {
      _isDoneBtnLoading = true;
    });
    _cubit.doneButtonPressed();
  }
}
