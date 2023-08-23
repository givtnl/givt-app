import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class VPCIntroItemFamily extends StatelessWidget {
  const VPCIntroItemFamily({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: Text(
              locals.vpcIntroFamilyText,
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
