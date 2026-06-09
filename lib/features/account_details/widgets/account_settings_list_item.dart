import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class AccountSettingsListItem extends StatelessWidget {
  const AccountSettingsListItem({
    required this.value,
    required this.leading,
    this.onTap,
    this.analyticsEvent,
    this.semanticsIdentifier,
    this.maxLines = 2,
    super.key,
  });

  final String value;
  final Widget leading;
  final VoidCallback? onTap;
  final AnalyticsEvent? analyticsEvent;
  final String? semanticsIdentifier;
  final int maxLines;

  bool get _isEnabled => onTap != null;

  void _handleTap() {
    if (!_isEnabled) {
      return;
    }
    if (analyticsEvent != null) {
      AnalyticsHelper.logEvent(
        eventName: analyticsEvent!.name,
        eventProperties: analyticsEvent!.parameters,
      );
    }
    onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final textColor = _isEnabled ? theme.primary20 : theme.neutralVariant60;

    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Center(child: leading),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: LabelMediumText(
              value,
              color: textColor,
              fontWeight: FontWeight.w600,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (_isEnabled) ...[
            const SizedBox(width: 12),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 20,
              color: theme.primary50.withValues(alpha: 0.5),
            ),
          ],
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.neutralVariant95, width: 2),
          ),
        ),
        child: _isEnabled
            ? Semantics(
                identifier: semanticsIdentifier,
                button: semanticsIdentifier != null,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleTap,
                    child: row,
                  ),
                ),
              )
            : row,
      ),
    );
  }
}
