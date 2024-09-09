import 'package:flutter/material.dart';
import 'package:givt_app/features/recurring_donations/detail/widgets/detail_year_separator.dart';
import 'package:givt_app/l10n/l10n.dart';

class UpcomingRecurringDonation extends StatelessWidget {
  const UpcomingRecurringDonation({
    required this.upcoming,
    super.key,
  });
  final Widget upcoming;
  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return Column(
      children: [
        YearBanner(locals.recurringDonationFutureDetailSameYear),
        Stack(
          children: [
            upcoming,
            Container(
              width: double.maxFinite,
              height: 60,
              margin: const EdgeInsets.only(left: 10),
              color: Colors.white.withAlpha(150),
            ),
          ],
        ),
      ],
    );
  }
}
