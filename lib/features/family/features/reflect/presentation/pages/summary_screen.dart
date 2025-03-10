import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/pages/record_summary_message_bottomsheet.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/fun_audio_player.dart';
import 'package:givt_app/features/family/features/reflect/bloc/summary_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/summary_details.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/summary_details_custom.dart';
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
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _cubit = getIt<SummaryCubit>();
  bool pressDown = false;

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
        appBar: const FunTopAppBar(
          title: 'Family summary',
        ),
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
                          if (details.players.isNotEmpty)
                            AvatarBar(
                                circleSize: 54,
                                uiModel: AvatarBarUIModel(avatarUIModels: [
                                  for (var i = 0;
                                      i < details.players.length;
                                      i++)
                                    AvatarUIModel(
                                      avatarUrl: details.players[i].pictureURL,
                                      text: details.players[i].firstName,
                                    ),
                                ]),
                                onAvatarTapped: (i) {}),

                          // stats button
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              top: 12,
                              bottom: 24,
                            ),
                            child: getTileStats(details),
                          ),
                          const SizedBox(height: 24),
                          // Record
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                const TitleMediumText(
                                  'Save a message for your memories',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                getAudioWidget(details),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
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
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: FunTile.gold(
                  titleBig: details.minutesPlayed == 1
                      ? '1 minute family time'
                      : '${details.minutesPlayed} minutes family time',
                  iconData: FontAwesomeIcons.solidClock,
                  assetSize: 32,
                  isPressedDown: true,
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.familyReflectSummaryMinutesPlayedClicked,
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
                    AmplitudeEvents.familyReflectSummaryGenerousDeedsClicked,
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
    );
  }

  FunButton getFunButton(SummaryDetails details) {
    const text = 'Done';

    final analyticEvent = AnalyticsEvent(
      AmplitudeEvents.familyReflectSummaryBackToHome,
    );

    if (details.showPlayer) {
      return FunButton(
        onTap: _cubit.doneButtonPressed,
        isPressedDown: pressDown,
        text: text,
        analyticsEvent: analyticEvent,
      );
    } else {
      return FunButton.secondary(
        onTap: _cubit.doneButtonPressed,
        isPressedDown: pressDown,
        text: text,
        analyticsEvent: analyticEvent,
      );
    }
  }

  Widget getAudioWidget(SummaryDetails details) {
    if (details.showPlayer) {
      return FunAudioPlayer(
        source: details.audioPath,
        onDelete: _cubit.onDeleteAudio,
      );
    } else {
      return FunTile.green(
        titleBig: 'Tap to record',
        titleSmall: 'Only your family can hear this',
        shrink: true,
        iconData: FontAwesomeIcons.microphone,
        assetSize: 32,
        onTap: () {
          RecordSummaryMessageBottomsheet.show(
            context,
            _cubit.audioAvailable,
          );
        },
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.summaryLeaveMessageClicked,
        ),
      );
    }
  }

  void _onCustom(BuildContext context, SummaryDetailsCustom custom) {
    switch (custom) {
      case ShowConfetti():
        setState(() {
          pressDown = true;
        });
        ConfettiDialog.show(context);
      case NavigateToNextScreen():
        context.goNamed(
          FamilyPages.profileSelection.name,
        );
    }
  }
}
