import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/generosity_hunt/presentation/pages/generosity_hunt_levels_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GenerosityHuntIntroPage extends StatelessWidget {
  const GenerosityHuntIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        title: 'Generosity Hunt',
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
          // Step list replacing title and subtext
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StepRow(
                number: '1',
                color: FamilyAppTheme.secondary90,
                text: 'Scan barcodes of products in your home',
                textColor: FamilyAppTheme.primary20,
              ),
              Divider(height: 32, color: FamilyAppTheme.neutralVariant95),
              _StepRow(
                number: '2',
                color: FamilyAppTheme.tertiary80,
                text: 'Hunt and find Givt Credits',
                textColor: FamilyAppTheme.primary20,
              ),
              Divider(height: 32, color: FamilyAppTheme.neutralVariant95),
              _StepRow(
                number: '3',
                color: FamilyAppTheme.highlight90,
                text: 'Donate Givt Credits to your favorite cause',
                textColor: FamilyAppTheme.primary20,
              ),
            ],
          ),
          const Spacer(),
          FunButton(
            text: "Let's go",
            analyticsEvent: AmplitudeEvents.letsGo.toEvent(),
            onTap: () => Navigator.of(context)
                .push(const GenerosityHuntLevelsPage().toRoute(context)),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.color,
    required this.text,
    required this.textColor,
  });
  final String number;
  final Color color;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: FamilyAppTheme.primary20,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
