import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_dropdown.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/platform_contribution/domain/models/platform_contribution_organization.dart';
import 'package:givt_app/l10n/l10n.dart';

/// Widget for displaying and managing a single organization's platform contribution
class PlatformContributionOrganizationItem extends StatelessWidget {
  const PlatformContributionOrganizationItem({
    required this.organization,
    required this.onToggleChanged,
    required this.onContributionLevelChanged,
    super.key,
  });

  final PlatformContributionOrganization organization;
  final ValueChanged<bool> onToggleChanged;
  final ValueChanged<PlatformContributionLevel> onContributionLevelChanged;

  String _getDisplayName(BuildContext context, PlatformContributionLevel level) {
    final l10n = context.l10n;
    switch (level) {
      case PlatformContributionLevel.common:
        return l10n.platformFeeCommonOption;
      case PlatformContributionLevel.generous:
        return l10n.platformFeeGenerousOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FunTheme.of(context).neutralVariant95,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Organization icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: FunTheme.of(context).primary95,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                    organization.type.icon,
                    width: 24,
                    height: 24,
                    color: FunTheme.of(context).primary40,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Organization name
              Expanded(
                child: TitleMediumText(
                  organization.name,
                  color: FunTheme.of(context).primary20,
                ),
              ),
              // Toggle switch
              Switch(
                value: organization.isEnabled,
                onChanged: onToggleChanged,
                activeColor: FunTheme.of(context).primary40,
                activeTrackColor: FunTheme.of(context).primary80,
                inactiveThumbColor: FunTheme.of(context).neutralVariant60,
                inactiveTrackColor: FunTheme.of(context).neutralVariant90,
              ),
            ],
          ),
          if (organization.isEnabled) ...[
            const SizedBox(height: 12),
            // Contribution level dropdown
            FunInputDropdown<PlatformContributionLevel>(
              value: organization.contributionLevel,
              items: PlatformContributionLevel.values,
              onChanged: onContributionLevelChanged,
              itemBuilder: (context, level) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: BodyMediumText(
                  _getDisplayName(context, level),
                  color: FunTheme.of(context).primary20,
                ),
              ),
              selectedItemBuilder: (context, level) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: BodyMediumText(
                  _getDisplayName(context, level),
                  color: FunTheme.of(context).primary40,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
