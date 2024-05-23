import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                'Oops, something went wrong.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We are having trouble getting the\nfunds from your card.\nPlease try again.',
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
