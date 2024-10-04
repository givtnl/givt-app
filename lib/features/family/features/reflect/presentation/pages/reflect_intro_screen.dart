import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/family_selection_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/stage_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class ReflectIntroScreen extends StatelessWidget {
  const ReflectIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        title: 'Gratitude Game',
        leading: GivtBackButtonFlat(),
      ),
      body: Column(
        children: [
          const Spacer(),
          SvgPicture.asset('assets/family/images/family_on_rug.svg'),
          const SizedBox(height: 32),
          const BodyMediumText(
            "Look back on today.\nShare what you're grateful for. Find ways to spread kindness together.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const Spacer(),
          FunButton(
            onTap: () {
              Navigator.of(context).push(StageScreen(
                buttonText: 'Start',
                onClickButton: () {
                  Navigator.of(context)
                      .push(const FamilySelectionScreen().toRoute(context));
                },
              ).toRoute(context));
            },
            text: "Let's go",
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.reflectAndShareLetsGoClicked,
            ),
          ),
        ],
      ),
    );
  }
}
