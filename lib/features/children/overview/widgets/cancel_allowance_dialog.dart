import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class CancelAllowanceDialog extends StatelessWidget {
  const CancelAllowanceDialog({
    required this.onCancel,
    super.key,
  });
  final VoidCallback onCancel;
  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    return Theme(
      data: theme,
      child: Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              trashAvatarIcon(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.35,
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to cancel the Recurring Amount?',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                "This will interrupt your child's giving journey.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FunButton.destructive(
                    onTap: () => {
                      onCancel.call(),
                      context
                        ..pop()
                        ..pop(),
                    },
                    text: 'Yes, cancel',
                    leftIcon: FontAwesomeIcons.xmark,
                    analyticsEvent: AnalyticsEvent(
                      AmplitudeEvents.cancelRGAYesClicked,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FunButton.secondary(
                    onTap: () => context.pop(),
                    text: 'No, go back',
                    analyticsEvent: AnalyticsEvent(
                      AmplitudeEvents.cancelRGANoClicked,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
