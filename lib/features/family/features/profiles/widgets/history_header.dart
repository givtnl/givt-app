import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'My givts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            context.pushNamed(Pages.history.name);
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.seeDonationHistoryPressed,
            );
          },
          style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
          ),
          child: const Text(
            'See all givts',
            style: TextStyle(
              color: Color(0xFF3B3240),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
