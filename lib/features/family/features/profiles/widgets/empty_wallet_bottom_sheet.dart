import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_secondary_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class EmptyWalletBottomSheet extends StatelessWidget {
  const EmptyWalletBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GivtBottomSheet(
      title: 'Oops, an empty Wallet',
      icon: walletEmptyIcon(),
      content: Text(
        'To continue giving you need to add more money to your Wallet. You\'ll need your parent to do this.',
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      primaryButton: GivtElevatedButton(
        text: 'Top up',
        leftIcon: FontAwesomeIcons.plus,
        onTap: () {
          context.pop();
        },
      ),
      secondaryButton: GivtElevatedSecondaryButton(
        text: 'Go back',
        leftIcon: const Icon(
          FontAwesomeIcons.arrowLeft,
          size: 24,
        ),
        onTap: () {
          context.pop();
        },
      ),
      closeAction: () {
        context.pop();
      },
    );
  }
}
