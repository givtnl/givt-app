import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class TopUpFailureDialog extends StatelessWidget {
  const TopUpFailureDialog({
    super.key,
  });

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
            warningIcon(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
            ),
            const SizedBox(height: 24),
            Text(
              'Oops, something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'We are having trouble getting the funds from your card. Please try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FunButton(
              text: 'OK',
              onTap: () => context.pop(),
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.okClicked,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
