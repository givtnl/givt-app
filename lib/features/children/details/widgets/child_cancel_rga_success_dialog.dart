import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class ChildCancelRGASuccessDialog extends StatelessWidget {
  const ChildCancelRGASuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'The Recurring Giving Allowance has been canceled.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontFamily: 'Raleway',
                    color: AppTheme.givtBlue,
                    letterSpacing: 0.25,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'You can set it up again at any time.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.givtBlue,
                    fontFamily: 'Raleway',
                  ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppTheme.primary80,
                side: const BorderSide(
                  width: 0,
                  color: Colors.transparent,
                ),
              ),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.primary30,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
