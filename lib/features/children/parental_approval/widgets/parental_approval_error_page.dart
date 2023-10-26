import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/utils/app_theme.dart';

class ParentalApprovalErrorPage extends StatelessWidget {
  const ParentalApprovalErrorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          //TODO: POEditor
          'Oops, something went wrong!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.givtBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 25,
        ),
        SvgPicture.asset(
          'assets/images/donation_states_declined.svg',
          width: 90,
          height: 90,
        ),
        const SizedBox(
          height: 35,
        ),
        Text(
          //TODO: POEditor
          'Please try again later',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.givtBlue,
              ),
        ),
      ],
    );
  }
}
