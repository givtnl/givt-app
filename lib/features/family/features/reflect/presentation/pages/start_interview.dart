import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/record_answer_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class StartInterviewScreen extends StatefulWidget {
  const StartInterviewScreen({super.key});

  @override
  State<StartInterviewScreen> createState() => _StartInterviewScreenState();
}

class _StartInterviewScreenState extends State<StartInterviewScreen> {
  var cubit = getIt<InterviewCubit>();
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
      child: Scaffold(
        backgroundColor: reporters.first.role!.color,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    _getTopWidget(),
                    const SizedBox(height: 16),
                    TitleMediumText(
                      'Pass the phone to the\n ${reporters.first.role!.name} ${reporters.first.firstName}',
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: FunButton(
                        onTap: () {
                          // push recording screen
                          Navigator.push(
                            context,
                            BaseStateConsumer(
                              cubit: cubit,
                              onInitial: (context) => const SizedBox.shrink(),
                              onCustom: (context, sidekick) =>
                                  Navigator.of(context).pushReplacement(
                                PassThePhone.toSidekick(sidekick)
                                    .toRoute(context),
                              ),
                              onData: (context, uiModel) {
                                return RecordAnswerScreen(
                                  uiModel: uiModel,
                                );
                              },
                            ).toRoute(context),
                          );
                        },
                        text: 'Interview Superhero',
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.reflectAndShareStartInterviewClicked,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
                    )),
                Positioned(
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      border: Border.all(
                        color: reporters[1].role!.color,
                        width: 6,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    child: SvgPicture.network(
                      reporters[1].pictureURL!,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                GameProfileItem(
                  profile: reporters.first,
                  displayName: false,
                  size: 140,
                ),
              ],
            ),
          ),
        );
      case >= 3:
        reporters = reporters.take(3).toList();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ...reporters.reversed.map((reporter) {
                  return Positioned(
                    right: reporters.indexOf(reporter) == 1 ? 1 : null,
                    left: reporters.indexOf(reporter) == 2 ? 1 : null,
                    child: reporters.indexOf(reporter) == 0
                        ? GameProfileItem(
                            profile: reporter,
                            displayName: false,
                            size: 140,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              border: Border.all(
                                color: reporter.role!.color,
                                width: 6,
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            child: SvgPicture.network(
                              reporter.pictureURL!,
                              width: 100,
                              height: 100,
                            ),
                          ),
                  );
                }).toList(),
              ],
            ),
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
}
