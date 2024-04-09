import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';

class GenerosityDailyCard extends StatelessWidget {
  const GenerosityDailyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(
              color: AppTheme.generosityChallangeCardBorder, width: 2),
          borderRadius: BorderRadius.circular(20),
          color: AppTheme.generosityChallangeCardBackground,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/generosity_challenge_placeholder.svg',
              height: 140,
              width: 140,
            ),
            const SizedBox(height: 16),
            const Text(
              'In a small village',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.givtGreen40,
                fontSize: 18,
                fontFamily: 'Rouna',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lived a craftsman Geppetto. One day he decided to make a wooden toy. He said to himself, “I will make a little boy and call him ‘Pinocchio’.”',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: AppTheme.givtGreen40,
                fontSize: 15,
                fontFamily: 'Rouna',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            GivtElevatedButton(
              onTap: () {},
              text: 'Placeholder',
            )
          ],
        ),
      ),
    );
  }
}
