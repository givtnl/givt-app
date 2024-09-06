import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
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
            warningIcon(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Please try again later or contact support@givt.app',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            FunButton(
              onTap: () => context.pop(),
              text: 'OK',
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
