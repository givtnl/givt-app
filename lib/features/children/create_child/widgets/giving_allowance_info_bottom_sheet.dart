import 'package:flutter/material.dart';

class GivingAllowanceInfoBottomSheet extends StatelessWidget {
  const GivingAllowanceInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.44,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          //TODO: POEditor
          Text(
            'Monthly giving allowance',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 15),
          //TODO: POEditor
          Text(
            "Empower your child with the joy of giving by setting up a Monthly Giving Allowance. This not only fosters a habit of generosity but also imparts important financial skills.   Funds will be added to your child's wallet immediately upon set up and replenished monthly, enabling them to learn about budgeting and decision-making while experiencing the fulfilment of making a difference.   Should you wish to change the amount or stop the giving allowance please reach out to us at support@givt.app",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
