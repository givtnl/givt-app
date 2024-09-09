import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class NoFundsErrorDialog extends StatelessWidget {
  const NoFundsErrorDialog({
    this.onClickContinue,
    super.key,
  });

  final void Function()? onClickContinue;

  static void show(BuildContext context, {void Function()? onClickContinue}) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.white,
      useRootNavigator: false,
      builder: (context) =>
          NoFundsErrorDialog(onClickContinue: onClickContinue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        SvgPicture.asset(
          'assets/images/wallet.svg',
          width: 100,
          height: 100,
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.vpcNoFundsSorry,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.givtBlue,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.vpcNoFundsError,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.givtBlue,
              ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            onPressed: () {
              context.pop();
              onClickContinue?.call();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              context.l10n.continueKey,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.childHistoryApproved,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
