import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

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
            const TitleMediumText('Easy giving, full control'),
            const SizedBox(height: 12),
            const BodyMediumText(
              'Set up a recurring donation you can adjust or cancel anytime.',
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
