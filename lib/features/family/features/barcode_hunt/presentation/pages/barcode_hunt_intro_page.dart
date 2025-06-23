import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/barcode_hunt/presentation/pages/barcode_hunt_levels_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class BarcodeHuntIntroPage extends StatelessWidget {
  const BarcodeHuntIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        title: 'Welcome',
        leading: GivtBackButtonFlat(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SvgPicture.asset(
            'assets/family/images/barcode_example_person.svg',
            height: 180,
          ),
          const SizedBox(height: 32),
          const TitleMediumText(
            'Play and earn',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const BodyMediumText(
            'Find the mystery product and raise credits to help your favorite cause',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FunButton(
            text: "Let's go",
            analyticsEvent: AnalyticsEvent(AmplitudeEvents.letsGo),
            onTap: () => Navigator.of(context)
                .push(const BarcodeHuntLevelsPage().toRoute(context)),
          ),
        ],
      ),
    );
  }
}
