import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/recommendation/widgets/charity_finder_app_bar.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class StartRecommendationScreen extends StatelessWidget {
  const StartRecommendationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CharityFinderAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 44),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Hi there!\n',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const TextSpan(
                    text: "Let's find charities that you like",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SvgPicture.asset(
                'assets/family/images/charity_finder_superhero.svg',
                alignment: Alignment.centerLeft,
                width: MediaQuery.sizeOf(context).width * .7,
              ),
            ),
            GivtElevatedButton(
              text: 'Start',
              onTap: () =>
                  context.pushReplacementNamed(FamilyPages.locationSelection.name),
            ),
          ],
        ),
      ),
    );
  }
}
