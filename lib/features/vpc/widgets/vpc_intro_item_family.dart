import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class VPCIntroItemFamily extends StatelessWidget {
  const VPCIntroItemFamily({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: Text(
              'We’ve made it easy for your children to take part in giving.\n\nIf you have multiple children, set up all your child profiles now. If you come out of the app you will need to give verifiable permission again.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppTheme.sliderIndicatorFilled),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Image.asset(
                'assets/images/vpc_intro_family.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
