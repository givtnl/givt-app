import 'package:flutter/material.dart';
import 'package:givt_app/features/vpc/widgets/vpc_notice_dialog.dart';
import 'package:givt_app/utils/app_theme.dart';

class VPCIntroItemSafety extends StatelessWidget {
  const VPCIntroItemSafety({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Before you create your child’s profile, we must obtain verifiable parental consent. This is achieved by making a \$1 transaction when you enter your card details.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppTheme.sliderIndicatorFilled),
          ),
          Image.asset(
            'assets/images/vpc_intro_safety.png',
          ),
          TextButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext ctx) => const VPCNoticeDialog(),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'See our direct notice',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: AppTheme.sliderIndicatorFilled),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.info_outline)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
