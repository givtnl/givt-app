import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class CancelAllowanceDialog extends StatelessWidget {
  const CancelAllowanceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            declinedIcon(width: 100, height: 100),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to cancel the Recurring Giving Allowance?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "This will interrupt your child's giving journey.",
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Go back',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //todo cancel allowance
                  },
                  child: Text(
                    'Yes, cancel',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
