import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/day_button.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/chat_icon_button.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GenerosityChallengeOverview extends StatefulWidget {
  const GenerosityChallengeOverview({
    required this.isDebug,
    super.key,
  });
  final bool isDebug;
  @override
  State<GenerosityChallengeOverview> createState() =>
      _GenerosityChallengeOverviewState();
}

class _GenerosityChallengeOverviewState
    extends State<GenerosityChallengeOverview> {
  Future<void> _undoProgress(int dayIndax) async {
    if (!widget.isDebug) {
      return;
    }

    final challenge = context.read<GenerosityChallengeCubit>();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Undo Challenge Progress'),
          content: Text(
            'Are you sure you want to undo generosity challenge progress including Day ${dayIndax + 1}?',
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(true),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
    if (true == result) {
      await challenge.undoProgress(dayIndax);
    }
  }

  Widget _deactivateButton() {
    return IconButton(
      onPressed: () async {
        final challenge = context.read<GenerosityChallengeCubit>();
        final result = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Complete Generosity Challenge?'),
              content: const Text(
                'Are you sure you want to complete the generosity challenge and go to the Givt app?',
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(true),
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
        if (true == result) {
          await challenge.completeChallenge();
          if (mounted) {
            context.goNamed(Pages.home.name);
          }
        }
      },
      icon: const Icon(
        FontAwesomeIcons.circleArrowLeft,
        color: AppTheme.givtGreen40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final challenge = context.watch<GenerosityChallengeCubit>();
    final userData = challenge.loadUserData();

    final arePersonalDetailsAvailable = userData.isNotEmpty;

    return Scaffold(
      appBar: GenerosityAppBar(
        title: 'Generosity Challenge',
        leading: widget.isDebug ? _deactivateButton() : null,
        actions: const [ChatIconButton()],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (arePersonalDetailsAvailable)
              SvgPicture.asset(
                'assets/images/generosity_challenge_backdrop.svg',
                width: MediaQuery.sizeOf(context).width,
                fit: BoxFit.fitWidth,
              ),
            Column(
              children: [
                if (arePersonalDetailsAvailable)
                  _buildGenerosityHeader(userData['lastName'].toString()),
                GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: GenerosityChallengeHelper.generosityChallengeDays,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final day = challenge.state.days[index];
                    return DayButton(
                      onLongPressed:
                          widget.isDebug ? () => _undoProgress(index) : null,
                      isCompleted: day.isCompleted,
                      isActive: challenge.state.activeDayIndex == index,
                      dayIndex: index,
                      onPressed: day.isCompleted ||
                              challenge.state.activeDayIndex == index
                          ? () {
                              AnalyticsHelper.logEvent(
                                eventName: AmplitudeEvents
                                    .generosityChallengeDayClicked,
                                eventProperties: {
                                  'day': index + 1,
                                },
                              );

                              // If the (pre)chat is available for the day, navigate to the chat screen
                              if (challenge.state.hasAvailableChat &&
                                  challenge.state.availableChatDayIndex ==
                                      index) {
                                context.goNamed(
                                  FamilyPages.generosityChallengeChat.name,
                                  extra:
                                      context.read<GenerosityChallengeCubit>(),
                                );
                              } else {
                                challenge.dayDetails(index);
                              }
                            }
                          : () {},
                    );
                  },
                ),
                if (widget.isDebug)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ToggleButtons(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.blue[700],
                      selectedColor: Colors.white,
                      fillColor: Colors.blue[200],
                      color: Colors.blue[400],
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        minWidth: 80,
                      ),
                      isSelected: [
                        challenge.state.unlockDayTimeDifference ==
                            UnlockDayTimeDifference.days,
                        challenge.state.unlockDayTimeDifference ==
                            UnlockDayTimeDifference.minutes,
                      ],
                      onPressed: challenge.toggleTimeDifference,
                      children: [
                        Text(UnlockDayTimeDifference.days.name),
                        Text(UnlockDayTimeDifference.minutes.name),
                      ],
                    ),
                  ),
                const Spacer(),
                GivtElevatedButton(
                  onTap: () {
                    context.read<FlowsCubit>().startInGenerosityCoinFlow();
                    context.pushNamed(FamilyPages.scanNFC.name);
                    AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.giveWithCoinInChallengeClicked,
                    );
                  },
                  leadingImage: coin(width: 32, height: 32),
                  text: 'Give with a coin',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerosityHeader(String name) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          SvgPicture.asset(
            'assets/images/family_avatar.svg',
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 14),
          Text(
            'The $name Family',
            style: const TextStyle(
              color: AppTheme.primary20,
              fontSize: 18,
              fontFamily: 'Rouna',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
}
