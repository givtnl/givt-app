import 'package:flutter/material.dart';
import 'package:givt_app/features/vpc/widgets/vpc_notice_dialog.dart';

class VPCIntroItemSafety extends StatelessWidget {
  const VPCIntroItemSafety({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Before you create your child’s profile, we must obtain verifiable parental consent. This is achieved by making a \$1 transaction when you enter your card details.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF184869),
            ),
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'See our direct notice',
                  style: TextStyle(
                    color: Color(0xFF184869),
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.info_outline,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
