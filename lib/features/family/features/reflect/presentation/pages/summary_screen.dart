import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/pages/record_summary_message_bottomsheet.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/fun_audio_player.dart';
import 'package:givt_app/features/family/features/reflect/bloc/summary_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/summary_details.dart';
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
        canPop: false,
        appBar: const FunTopAppBar(
          title: 'Family summary',
        ),
        body: BaseStateConsumer(
          cubit: _cubit,
          onData: (context, details) {
            return SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    FunTag.purple(text: DateTime.now().formattedFullMonth),
                    const SizedBox(height: 16),
                    if (details.players.isNotEmpty)
                      AvatarBar(
                          circleSize: 54,
                          uiModel: AvatarBarUIModel(avatarUIModels: [
                            for (var i = 0; i < details.players.length; i++)
                              AvatarUIModel(
                                avatarUrl: details.players[i].pictureURL,
                                text: details.players[i].firstName,
                              ),
                          ]),
                          onAvatarTapped: (i) {}),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          getTileStats(details),
                          const SizedBox(height: 24),
                          const TitleMediumText(
                            'Save a message for your memories',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          getAudioWidget(details),
                          const SizedBox(height: 24),
                          getFunButton(details),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
        const SizedBox(width: 16),
        Expanded(
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
      ],
    );
  }

  FunButton getFunButton(SummaryDetails details) {
    const text = 'Done';
    void onTap() {
      if (details.audioPath.isNotEmpty) {
        sendAudioAndNavigate(details.audioPath);
        return;
      }
      navigateWithConfetti();
    }

    final analyticEvent = AnalyticsEvent(
      AmplitudeEvents.familyReflectSummaryBackToHome,
    );

    if (details.showPlayer) {
      return FunButton(
        onTap: onTap,
        isPressedDown: pressDown,
        text: text,
        analyticsEvent: analyticEvent,
      );
    } else {
      return FunButton.secondary(
        onTap: onTap,
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

  Future<void> sendAudioAndNavigate(String path) async {
    await _cubit.shareAudio(path);
    await navigateWithConfetti();
  }

  Future<void> navigateWithConfetti() async {
    _cubit.onCloseGame();
    setState(() {
      pressDown = true;
    });
    await ConfettiDialog.show(context);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.goNamed(
        FamilyPages.profileSelection.name,
      );
    }
  }
}
