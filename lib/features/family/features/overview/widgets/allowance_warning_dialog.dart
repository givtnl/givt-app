import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class AllowancesWarningDialog extends StatelessWidget {
  const AllowancesWarningDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/wallet.svg',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.almostDone,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.weHadTroubleGettingAllowance,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.noWorriesWeWillTryAgain,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: AppTheme.childGivingAllowanceHint,
                ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.only(bottom: 24),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.4,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.givtGreen60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              'Continue',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.givtGreen40,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ],
    );
  }
}
