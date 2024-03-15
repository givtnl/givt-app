import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class EditCardDetailsFailure extends StatelessWidget {
  const EditCardDetailsFailure({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.editPaymentDetailsFailure,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.givtBlue,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(
          height: 40,
        ),
        SvgPicture.asset(
          'assets/images/donation_states_error.svg',
          width: 80,
          height: 80,
        ),
      ],
    );
  }
}
