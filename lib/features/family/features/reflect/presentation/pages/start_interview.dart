import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/interview_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/gratitude_selection_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/record_answer_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class StartInterviewScreen extends StatefulWidget {
  const StartInterviewScreen({super.key});

  @override
  State<StartInterviewScreen> createState() => _StartInterviewScreenState();
}

class _StartInterviewScreenState extends State<StartInterviewScreen> {
  InterviewCubit cubit = getIt<InterviewCubit>();
  List<GameProfile> reporters = [];

  @override
  void initState() {
    super.initState();
    reporters = cubit.getReporters();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: PassThePhone(
        user: reporters.first,
        customHeader: _getTopWidget(),
        onTap: (context) {
          // push recording screen
          Navigator.pushReplacement(
            context,
            BaseStateConsumer(
              cubit: cubit,
              onInitial: (context) => const SizedBox.shrink(),
              onCustom: _handleCustom,
              onData: (context, uiModel) {
                return RecordAnswerScreen(
                  uiModel: uiModel,
                );
              },
            ).toRoute(context),
          );
        },
        buttonText: 'Start Interview',
      ),
    );
  }

  Widget _getTopWidget() {
    return reporters.length > 1 ? _getReportersWidget() : _getReporterWidget();
  }

  Widget _getReportersWidget() {
    switch (reporters.length) {
      case 1:
        return GameProfileItem(
          profile: reporters.first,
          displayName: false,
          displayRole: false,
          size: 140,
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(
                  left: 1,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GameProfileItem(
                    profile: reporters[1],
                    displayName: false,
                    size: 120,
                    displayRole: false,
                  ),
                ),
                GameProfileItem(
                  profile: reporters.first,
                  displayName: false,
                  displayRole: false,
                  size: 140,
                ),
              ],
            ),
          ),
        );
      case >= 3:
        reporters = reporters.take(3).toList();
        return SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...reporters.reversed.map((reporter) {
                return Positioned(
                  right: reporters.indexOf(reporter) == 1 ? 36 : null,
                  left: reporters.indexOf(reporter) == 2 ? 36 : null,
                  child: reporters.indexOf(reporter) == 0
                      ? GameProfileItem(
                          profile: reporter,
                          displayName: false,
                          size: 140,
                          displayRole: false,
                        )
                      : GameProfileItem(
                          profile: reporter,
                          displayName: false,
                          size: 120,
                          displayRole: false,
                        ),
                );
              }),
            ],
          ),
        );
      default:
        return GameProfileItem(
          profile: reporters.first,
          displayName: false,
          size: 140,
        );
    }
  }

  Widget _getReporterWidget() {
    return GameProfileItem(
      profile: reporters.first,
      displayName: false,
      size: 140,
    );
  }

  IconData _getIconPerRole(GameProfile profile) {
    switch (profile.role.runtimeType) {
      case SuperHero:
        return FontAwesomeIcons.mask;
      case Sidekick:
        return FontAwesomeIcons.solidHandshake;
      case Reporter:
      default:
        return FontAwesomeIcons.microphone;
    }
  }

  void _handleCustom(BuildContext context, InterviewCustom custom) {
    switch (custom) {
      case final PassThePhoneToSidekick data:
        Navigator.pushReplacement(
          context,
          PassThePhone.toSidekick(data.profile).toRoute(context),
        );
      case GratitudeSelection():
        Navigator.of(context).pushReplacement(
          const GratitudeSelectionScreen().toRoute(context),
        );
    }
  }
}
