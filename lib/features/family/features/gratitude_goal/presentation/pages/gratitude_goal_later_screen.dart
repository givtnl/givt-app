import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class GratitudeGoalLaterScreen extends StatefulWidget {
  const GratitudeGoalLaterScreen({super.key});

  @override
  State<GratitudeGoalLaterScreen> createState() =>
      _GratitudeGoalLaterScreenState();
}

class _GratitudeGoalLaterScreenState extends State<GratitudeGoalLaterScreen> {
  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: const EdgeInsets.symmetric(horizontal: 24),
      appBar: const FunTopAppBar(
        title: 'Build a habit',
        leading: GivtBackButtonFlat(),
      ),
      body: Column(
        children: [
          const Spacer(),
          const TitleMediumText(
            'No worries! The mission stays open until you’re ready to grow your gratitude superpowers!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          SvgPicture.asset(
            'assets/family/images/league/standing_superhero.svg',
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: FunButton(
              onTap: () => context.goNamed(FamilyPages.profileSelection.name),
              text: context.l10n.buttonDone,
              analyticsEvent: AnalyticsEventName.gratitudeGoalLaterDoneClicked.toEvent(),
            ),
          ),
        ],
      ),
    );
  }
}
