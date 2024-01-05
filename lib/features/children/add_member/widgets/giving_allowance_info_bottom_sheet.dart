import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class GivingAllowanceInfoBottomSheet extends StatelessWidget {
  const GivingAllowanceInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 5, right: 30, bottom: 50),
        child: Column(
          children: [
            Text(
              context.l10n.createChildGivingAllowanceTitle,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 15),
            Text(
              context.l10n.createChildGivingAllowanceText,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
