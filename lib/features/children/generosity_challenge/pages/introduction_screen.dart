import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/registration/widgets/acceptPolicyRow.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class GenrosityIntorductionScreen extends StatefulWidget {
  const GenrosityIntorductionScreen({super.key});

  @override
  State<GenrosityIntorductionScreen> createState() =>
      _GenrosityIntorductionScreenState();
}

class _GenrosityIntorductionScreenState
    extends State<GenrosityIntorductionScreen> {
  bool _acceptPolicy = false;

  @override
  Widget build(BuildContext context) {
    const pictureHeight = 150.0;
    return Scaffold(
      appBar: const GenerosityAppBar(
        title: 'Generosity Challenge',
        leading: null,
      ),
      backgroundColor: AppTheme.givtLightBackgroundGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: pictureHeight - 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: AppTheme.tertiary90,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi Superheroes!',
                          style: purpleCardTextStyle?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Thanks for reading my letter and for coming to the rescue. \n \nAre you ready to accept the challenge to spread generosity?',
                          style: purpleCardTextStyle?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '— The Mayor of Tulsa',
                    style: TextStyle(
                      color: Color(0xFF003920),
                      fontSize: 18,
                      fontFamily: 'Rouna',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/images/mayor.svg',
                height: pictureHeight,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AcceptPolicyRow(
              onTap: (value) {
                setState(() {
                  _acceptPolicy = value!;
                });
              },
              checkBoxValue: _acceptPolicy,
            ),
            GivtElevatedButton(
              isDisabled: !_acceptPolicy,
              onTap: () {
                GenerosityChallengeHelper.activate();
                // should link to chat when finished
                context.goNamed(Pages.generosityChallenge.name);
              },
              text: 'Accept the challenge',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  TextStyle? get purpleCardTextStyle =>
      AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
        fontSize: 20,
        color: AppTheme.tertiary20,
        fontFamily: 'Rouna',
      );
}
