import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';

class PledgesEmptyState extends StatelessWidget {
  const PledgesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/givt_calendar.svg',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 16),
          TitleMediumText(
            locals.pledgesEmptyStateTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          BodyMediumText(
            locals.pledgesEmptyStateDescription,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
