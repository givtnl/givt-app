import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/gratitude_goal/presentation/pages/gratitude_goal_recognize_this_screen.dart';
import 'package:givt_app/features/family/features/tutorial/domain/tutorial_repository.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GratitudeGoalEntryScreen extends StatefulWidget {
  const GratitudeGoalEntryScreen({super.key, this.fromTutorial = false});

  final bool fromTutorial;

  @override
  State<GratitudeGoalEntryScreen> createState() =>
      _GratitudeGoalEntryScreenState();
}

class _GratitudeGoalEntryScreenState extends State<GratitudeGoalEntryScreen> {
  @override
  void initState() {
    super.initState();
    getIt<TutorialRepository>().gratitudeMissionStartedFromTutorial =
        widget.fromTutorial;
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        title: 'Build a habit',
      ),
      body: Column(
        children: [
          const Spacer(),
          SvgPicture.asset(
            'assets/family/images/league/standing_superhero.svg',
          ),
          const SizedBox(
            height: 16,
          ),
          const TitleMediumText(
            'Grow your family’s Gratitude superpowers',
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          const BodySmallText(
            'Let’s look at your family and set a goal to build a habit of gratitude and generosity',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FunButton(
            text: 'Let’s do it',
            onTap: () => Navigator.of(context).push(
              const GratitudeGoalRecognizeThisScreen().toRoute(context),
            ),
            analyticsEvent: AmplitudeEvents.gratitudeGoalStartClicked.toEvent(),
          ),
        ],
      ),
    );
  }
}
