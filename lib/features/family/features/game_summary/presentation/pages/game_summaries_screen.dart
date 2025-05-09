import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/game_summary/cubit/game_summaries_cubit.dart';
import 'package:givt_app/features/family/features/game_summary/data/models/game_summary_item.dart';
import 'package:givt_app/features/family/features/game_summary/presentation/pages/game_summary_screen.dart';
import 'package:givt_app/features/family/helpers/helpers.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/errors/retry_error_widget.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class GameSummariesScreen extends StatefulWidget {
  const GameSummariesScreen({super.key});

  @override
  State<GameSummariesScreen> createState() => _GameSummariesScreenState();
}

class _GameSummariesScreenState extends State<GameSummariesScreen> {
  final _cubit = getIt<GameSummariesCubit>();
  @override
  void initState() {
    super.initState();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: EdgeInsets.zero,
      appBar: const FunTopAppBar(
        title: 'Memories',
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, summaries) {
          if (summaries.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  SvgPicture.asset(
                    'assets/family/images/empty_flag.svg',
                    width: 140,
                    height: 140,
                  ),
                  const SizedBox(height: 16),
                  BodyMediumText(
                    'You haven’t played the Gratitude Game yet',
                    color: Colors.black.withOpacity(0.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return buildListView(summaries);
        },
        onError: (context, error) => RetryErrorWidget(
          onTapPrimaryButton: _cubit.init,
          secondaryButtonText: 'Go Home',
          onTapSecondaryButton: () => context.pop(),
          secondaryButtonAnalyticsEvent: AnalyticsEvent(
            AmplitudeEvents.returnToHomePressed,
          ),
        ),
        onLoading: (context) {
          if (_cubit.gameSummaries.isEmpty) {
            return const FullScreenLoadingWidget();
          } else {
            return Stack(
              children: [
                buildListView(_cubit.gameSummaries),
                ColoredBox(
                  color: Colors.white.withOpacity(0.5),
                  child: const SizedBox.expand(),
                ),
                const Center(
                  child: CustomCircularProgressIndicator(),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildListView(List<GameSummaryItem> summaries) {
    return ListView.builder(
      itemCount: summaries.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            buildTile(summaries[index]),
            if (index < summaries.length - 1)
              const Divider(
                color: FamilyAppTheme.neutralVariant95,
                thickness: 1,
                height: 1,
              ),
          ],
        );
      },
    );
  }

  Widget buildTile(GameSummaryItem summary) => InkWell(
        onTap: () async {
          final uiModel = await _cubit.getSummaryUIModel(summary.id);
          unawaited(
            Navigator.of(context).push(
              GameSummaryScreen(uiModel: uiModel).toRoute(context),
            ),
          );

          // Track when user taps on a specific memory summary
          unawaited(
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.memorySummaryClicked,
              eventProperties: {
                'memory_id': summary.id,
                'memory_date': summary.dateLocalTime.formattedFullUSDate,
                'player_count': summary.players.length,
              },
            ),
          );
        },
        highlightColor: FamilyAppTheme.primary60.withOpacity(0.1),
        splashColor: FamilyAppTheme.primary60.withOpacity(0.1),
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          title: SizedBox(
            height: 32,
            child: Stack(
              children: [
                for (int i = 0; i < summary.players.length; i++)
                  Positioned(
                    left: i * 24.0,
                    child: FunAvatar.fromProfile(
                      summary.players[i],
                      size: 32,
                    ),
                  ),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelMediumText(
                summary.dateLocalTime.formattedFullUSDate,
                color: FamilyAppTheme.primary50,
              ),
              const SizedBox(width: 16),
              FaIcon(
                FontAwesomeIcons.chevronRight,
                color: FamilyAppTheme.primary50.withOpacity(0.5),
              ),
            ],
          ),
        ),
      );
}
