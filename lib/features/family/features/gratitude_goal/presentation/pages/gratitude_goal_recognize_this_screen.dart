import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/gratitude_goal/presentation/pages/gratitude_goal_select_behavior_screen.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_text_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_tag.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GratitudeGoalRecognizeThisScreen extends StatelessWidget {
  const GratitudeGoalRecognizeThisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: const EdgeInsets.symmetric(horizontal: 24),
      appBar: const FunTopAppBar(
        title: 'Build a habit',
        leading: kDebugMode ? GivtBackButtonFlat() : null,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset(
                  'assets/family/images/gratitude_goal_sad.png',
                ),
                const SizedBox(
                  height: 32,
                ),
                const TitleMediumText(
                  'Recognize this?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                const BodyMediumText(
                  '"My 9-year-old got a box of Lego from our neighbor but refused to share it with his sister. I’d love them to be more grateful and generous!"',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12,
                ),
                FunTag.secondary(
                  text: 'Cindy 33 , Tulsa OK',
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 24),
                FunButton(
                  text: 'Yes, of course',
                  onTap: () =>
                      _navigateToGratitudeGoalSelectBehaviorScreen(
                    context,
                    isRecognized: true,
                  ),
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.gratitudeGoalYesOfCourseClicked,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FunTextButton(
                  text: 'No, not really',
                  onTap: () =>
                      _navigateToGratitudeGoalSelectBehaviorScreen(
                    context,
                    isRecognized: false,
                  ),
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.gratitudeGoalNoNotReallyClicked,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToGratitudeGoalSelectBehaviorScreen(
    BuildContext context, {
    required bool isRecognized,
  }) {
    Navigator.of(context).push(
      GratitudeGoalSelectBehaviorScreen(isRecognized: isRecognized)
          .toRoute(context),
    );
  }
}
