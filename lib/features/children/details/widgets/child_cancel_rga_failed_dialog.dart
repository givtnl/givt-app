import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class ChildCancelRGAFailedDialog extends StatelessWidget {
  const ChildCancelRGAFailedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            warningIcon(),
            const SizedBox(height: 16),
            Text(
              'Oops something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontFamily: 'Raleway',
                    color: AppTheme.givtBlue,
                    letterSpacing: 0.25,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please try again later or contact support@givt.app',
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
                backgroundColor: AppTheme.error80,
                side: const BorderSide(
                  width: 0,
                  color: Colors.transparent,
                ),
              ),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.error30,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
