import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/record_answer_screen.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: GivtElevatedButton(
                      onTap: () {
                        // push recording screen
                        Navigator.push(
                          context,
                          RecordAnswerScreen(
                            reporters: reporters,
                          ).toRoute(context),
                        );
                      },
                      text: 'Interview Superhero',
                    ),
                  ),
                ],
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
    bool many = reporters.length > 2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...reporters.map((reporter) {
          final isFirst = reporter == reporters.first;

          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    border: Border.all(
                      color: reporter.role!.color,
                      width: 8,
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  child: SvgPicture.network(
                    reporter.pictureURL!,
                    width: isFirst
                        ? 120
                        : many
                            ? 60
                            : 80,
                    height: isFirst
                        ? 120
                        : many
                            ? 60
                            : 80,
                  ),
                ),
                if (isFirst)
                  Positioned(
                    bottom: 0,
                    left: 50,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: reporter.role?.color ?? Colors.red,
                      ),
                      child: Icon(
                        _getIconPerRole(reporter),
                        color: FamilyAppTheme.primary20,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _getReporterWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70),
        border: Border.all(
          color: reporters.first.role!.color,
          width: 8,
        ),
      ),
      padding: EdgeInsets.zero,
      child: SvgPicture.network(
        reporters.first.pictureURL!,
        width: 120,
        height: 120,
      ),
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
