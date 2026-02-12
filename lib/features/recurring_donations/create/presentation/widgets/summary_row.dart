import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    required this.icon, required this.label, required this.value, required this.onEdit, super.key,
    this.analyticsEvent,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onEdit;
  final AnalyticsEvent? analyticsEvent;

  void _handleEdit() {
    if (analyticsEvent != null) {
      AnalyticsHelper.logEvent(
        eventName: analyticsEvent!.name,
        eventProperties: analyticsEvent!.parameters,
      );
    }
    onEdit();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: FamilyAppTheme.primary40,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelMediumText(label),
                BodySmallText.primary40(value),
              ],
            ),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.penToSquare,
                color: FamilyAppTheme.primary40),
            onPressed: _handleEdit,
          ),
        ],
      ),
    );
  }
} 