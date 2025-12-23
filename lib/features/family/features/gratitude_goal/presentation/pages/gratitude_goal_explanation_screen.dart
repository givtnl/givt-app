import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/models/behavior_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/presentation/pages/gratitude_goal_set_a_goal_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class GratitudeGoalExplanationScreen extends StatefulWidget {
  const GratitudeGoalExplanationScreen({required this.behavior, super.key});

  final BehaviorOptions behavior;

  @override
  State<GratitudeGoalExplanationScreen> createState() =>
      _GratitudeGoalExplanationScreenState();
}

class _GratitudeGoalExplanationScreenState
    extends State<GratitudeGoalExplanationScreen> {
  int _index = 0;
  int _tapAmount = 0;
  bool _isEndOfExplanation = false;

  late List<String> explanations;

  @override
  void initState() {
    super.initState();
    explanations = [
      'The best way to change behavior is to focus on building habits...',
      'This requires consistent repetition...',
      'I know...there’s already a lot on your plate.',
      widget.behavior.captainExplanation,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: const EdgeInsets.symmetric(horizontal: 24),
      appBar: const FunTopAppBar(
        title: 'Build a habit',
        leading: GivtBackButtonFlat(),
      ),
      body: _isEndOfExplanation
          ? _endOfExplanationLayout()
          : _explanationLayout(),
    );
  }

  Widget _endOfExplanationLayout() {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(
          'assets/family/images/avatar_captain.svg',
        ),
        const SizedBox(
          height: 16,
        ),
        const TitleMediumText(
          'Let’s use the gratitude game to build this habit in just a few weeks',
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        FunButton(
          text: 'Let’s do it',
          onTap: () => Navigator.of(context).push(
            GratitudeGoalSetAGoalScreen(behavior: widget.behavior)
                .toRoute(context),
          ),
          analyticsEvent: AnalyticsEventName.gratitudeGoalLetsDoItClicked.toEvent(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _explanationLayout() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tapAmount++;
        });
        AnalyticsHelper.logEvent(
          eventName: AnalyticsEventName.gratitudeGoalTapToContinueClicked,
          eventProperties: {
            'screen_index': _index,
            'amount_tapped': _tapAmount,
          },
        );
        if (_index == explanations.length - 1) {
          setState(() {
            _isEndOfExplanation = true;
          });
        } else {
          setState(() {
            _index++;
          });
        }
      },
      child: ColoredBox(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                const Spacer(),
                Container(
                  constraints: const BoxConstraints(minHeight: 116),
                  alignment: Alignment.center,
                  child: TitleMediumText(
                    explanations[_index],
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SvgPicture.asset(
                  'assets/family/images/league/standing_superhero.svg',
                ),
                const Spacer(),
              ],
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: LabelLargeText('Tap to continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
