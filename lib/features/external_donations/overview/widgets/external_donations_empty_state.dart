import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class ExternalDonationsEmptyState extends StatelessWidget {
  const ExternalDonationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    final theme = FunTheme.of(context);

    return Center(
      child: Column(
        children: [
          _buildIllustration(),
          const SizedBox(height: 8),
          FunTag(
            text: locals.externalDonationsEmptyStateNotProcessedTag,
            textColor: theme.neutral40,
            accentColor: theme.neutral95,
            margin: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          TitleMediumText(
            locals.externalDonationsEmptyStateTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          BodyMediumText(
            locals.externalDonationsEmptyStateDescription,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return SvgPicture.asset(
      'assets/images/givt_calendar.svg',
      width: 200,
      height: 200,
    );
  }
}
