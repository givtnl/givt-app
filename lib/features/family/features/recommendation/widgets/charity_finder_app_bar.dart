import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/widgets/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/wallet.dart';

class CharityFinderAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CharityFinderAppBar({this.showWallet = false, super.key,});
  final bool showWallet;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GivtBackButtonFlat(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.onPrimary,
      ),
      title: Text(
        'Charity Finder',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
      actions: [
        if (showWallet)
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Wallet(),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
