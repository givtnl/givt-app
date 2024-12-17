import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/game_summary/cubit/game_summaries_cubit.dart';
import 'package:givt_app/features/family/features/game_summary/data/models/game_summary_item.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/errors/retry_error_widget.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/string_datetime_extension.dart';
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
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: EdgeInsets.zero,
      appBar: const FunTopAppBar(
        title: 'Game Summaries',
        leading: GivtBackButtonFlat(),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, summaries) {
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
        },
        onError: (context, error) => RetryErrorWidget(
          onTapPrimaryButton: _cubit.init,
          secondaryButtonText: 'Go Home',
          onTapSecondaryButton: () => context.pop(),
          secondaryButtonAnalyticsEvent: AnalyticsEvent(
            AmplitudeEvents.returnToHomePressed,
          ),
        ),
        onLoading: (context) => const FullScreenLoadingWidget(),
      ),
    );
  }

  Widget buildTile(GameSummaryItem summary) => InkWell(
        onTap: () {
          print('GameSummaryItem: ${summary.id}');
          // TODO push a game summary page
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
                    child: SvgPicture.network(
                      summary.players[i].pictureURL,
                      width: 32,
                      height: 32,
                    ),
                  ),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelMediumText(
                summary.date.formatDate(
                  context.l10n,
                  showYear: true,
                ),
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
