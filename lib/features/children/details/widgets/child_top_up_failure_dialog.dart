import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_oval_green_button.dart';
import 'package:givt_app/shared/widgets/dialogs/card_dialog.dart';
import 'package:go_router/go_router.dart';

class TopUpFailureDialog extends StatelessWidget {
  const TopUpFailureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CardDialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset('assets/images/wallet.svg'),
          Column(
            children: [
              Text(
                context.l10n.somethingWentWrong,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.topUpFundsFailureText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          CustomOvalGreenButton(title: 'OK', onPressed: () => context.pop()),
        ],
      ),
    );
  }
}
