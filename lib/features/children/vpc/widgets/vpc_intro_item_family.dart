import 'package:flutter/material.dart';
import 'package:givt_app/features/children/vpc/widgets/vpc_intro_item_image.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class VPCIntroItemFamily extends StatelessWidget {
  const VPCIntroItemFamily({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            locals.vpcIntroFamilyText,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppTheme.sliderIndicatorFilled),
          ),
        ),
        const Spacer(flex: 1),
        const VPCIntroItemImage(
          background: 'assets/images/vpc_intro_family_bg.svg',
          foreground: 'assets/images/vpc_intro_family.svg',
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
