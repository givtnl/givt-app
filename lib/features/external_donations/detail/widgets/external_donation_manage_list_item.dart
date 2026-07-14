import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class ExternalDonationManageListItem extends StatelessWidget {
  const ExternalDonationManageListItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.analyticsEvent,
    super.key,
  });

  final FaIconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final AnalyticsEvent? analyticsEvent;

  void _handleTap() {
    if (analyticsEvent != null) {
      AnalyticsHelper.logEvent(
        eventName: analyticsEvent!.name,
        eventProperties: analyticsEvent!.parameters,
      );
    }
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.neutralVariant95, width: 1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                FaIcon(icon, size: 20, color: theme.primary20),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelMediumText(
                        label,
                        color: theme.primary20,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 4),
                      BodySmallText(
                        value,
                        color: theme.neutral50,
                      ),
                    ],
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.pen,
                  size: 18,
                  color: theme.primary50.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
