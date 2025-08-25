import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_entry_list.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_highlighted_heroes.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_overview_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/actions/actions.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_tag.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';

class LeagueOverview extends StatelessWidget {
  const LeagueOverview({
    required this.uiModel,
    this.dateLabel,
    super.key,
    this.onTap,
    this.isPressedDown = false,
    this.isBtnLoading = false,
  });

  final LeagueOverviewUIModel uiModel;
  final String? dateLabel;
  final bool isPressedDown;
  final bool isBtnLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final firstName = uiModel.entries?.firstOrNull?.name;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TitleLargeText(
                  uiModel.isInGameVersion && firstName.isNotNullAndNotEmpty()
                      ? '$firstName! Congrats'
                      : 'Heroes of the Week',
                ),
              ),
              if (dateLabel != null) const SizedBox(height: 8),
              if (dateLabel != null)
                FunTag.tertiary(
                  text: dateLabel!,
                  iconData: FontAwesomeIcons.solidClock,
                  iconSize: 12,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              const SizedBox(height: 32),
              if (uiModel.entries != null)
                LeagueHighlightedHeroes(uiModels: uiModel.entries!),
              const SizedBox(height: 16),
              if (uiModel.entries != null)
                LeagueEntryList(
                  physics: const ClampingScrollPhysics(),
                  uiModels: uiModel.entries!,
                  shrinkWrap: true,
                ),
            ],
          ),
        ),
        if (uiModel.isInGameVersion && onTap != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: FunButton(
                onTap: onTap,
                isLoading: isBtnLoading,
                isPressedDown: isPressedDown,
                text: context.l10n.buttonContinue,
                analyticsEvent: AmplitudeEvents.continueClicked.toEvent(),
              ),
            ),
          )
      ],
    );
  }
}
