import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';

class RecurringDonationsEmptyState extends StatelessWidget {
  const RecurringDonationsEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            _buildIllustration(),
            const SizedBox(height: 16),
            TitleMediumText(context.l10n.recurringDonationsEmptyStateTitle),
            const SizedBox(height: 12),
            BodyMediumText(
              context.l10n.recurringDonationsEmptyStateDescription,
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
