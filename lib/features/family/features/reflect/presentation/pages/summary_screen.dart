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
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/fun_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/dialogs/confetti_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
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
                AmplitudeEvents.familyReflectSummaryGenerousDeedsClicked,
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
      case NavigateToNextScreen():
        _navigateToNextScreen(context);
      case final ShowInterviewPopup event:
        _showInterviewPopup(
          context,
          event.uiModel,
          useDefaultImage: event.useDefaultImage,
        );
    }
  }

  void _showConffetti(BuildContext context) {
    setState(() {
      pressDown = true;
    });
    ConfettiDialog.show(context);
  }

  void _navigateToNextScreen(BuildContext context) {
    setState(() {
      _isDoneBtnLoading = false;
    });
    context.goNamed(
      FamilyPages.profileSelection.name,
    );
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
        _navigateToNextScreen(context);
      },
      onClickSecondary: () {
        context.pop();
        _showConffetti(context);
        _navigateToNextScreen(context);
      },
    );
  }

  Future<void> launchCalendlyUrl() async {
    const calendlyLinK = 'https://calendly.com/andy-765/45min';

    final url = Uri.parse(calendlyLinK);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // do nothing, we're probably on a weird platform/ simulator
    }
  }

  void _onTapDoneBtn() {
    setState(() {
      _isDoneBtnLoading = true;
    });
    _cubit.doneButtonPressed();
  }
}
