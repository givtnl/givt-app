import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class CancelAllowanceDialog extends StatelessWidget {
  const CancelAllowanceDialog({
    required this.onCancel,
    super.key,
  });
  final VoidCallback onCancel;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            declinedIcon(width: 100, height: 100),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to cancel the Recurring Giving Allowance?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'Raleway',
                    color: AppTheme.givtBlue,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              "This will interrupt your child's giving journey.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.givtBlue,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Go back',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.givtBlue,
                        ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => {
                    onCancel.call(),
                    context
                      ..pop()
                      ..pop(),
                  },
                  style: OutlinedButton.styleFrom(
                      backgroundColor: AppTheme.error80,
                      side: const BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      )),
                  child: Text(
                    'Yes, cancel',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.error30,
                        ),
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
