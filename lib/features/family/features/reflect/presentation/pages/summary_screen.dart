import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/pages/record_summary_message_.bottomsheet.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/audio_player.dart';
import 'package:givt_app/features/family/features/reflect/bloc/summary_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/dialogs/confetti_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _cubit = getIt<SummaryCubit>();
  bool pressDown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: FunScaffold(
        minimumPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        canPop: false,
        appBar: const FunTopAppBar(
          title: 'Awesome work heroes!',
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
                    TitleMediumText(
                      details.isShareableSummary
                          ? 'Let’s share your superhero activity with the rest of the family!'
                          : 'Your mission to turn your gratitude into generosity was a success!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    SvgPicture.asset(
                        'assets/family/images/family_superheroes.svg'),
                    const SizedBox(height: 24),
                    Row(
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
                              AmplitudeEvents
                                  .familyReflectSummaryMinutesPlayedClicked,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
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
                      ],
                    ),
                    if (details.showRecorder) const SizedBox(height: 8),
                    if (details.showRecorder)
                      FunButton.secondary(
                        leftIcon: FontAwesomeIcons.microphone,
                        onTap: () {
                          RecordSummaryMessageBottomsheet.show(
                            context,
                            details.adultName,
                            _cubit.audioAvailable,
                          );
                        },
                        text: 'Leave a message',
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.summaryLeaveMessageClicked,
                        ),
                      ),
                    if (details.showPlayer)
                      FunAudioPlayer(
                          source: details.audioPath, onDelete: () {}),
                    const SizedBox(height: 8),
                    FunButton(
                      onTap: () {
                        if (details.audioPath.isNotEmpty) {
                          sendAudioAndNavigate(details.audioPath);
                          return;
                        }
                        navigateWithConfetti();
                      },
                      isPressedDown: pressDown,
                      text: details.isShareableSummary
                          ? pressDown
                              ? 'Sent!'
                              : 'Share summary'
                          : 'Back to home',
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.familyReflectSummaryBackToHome,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
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
