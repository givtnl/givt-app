import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class GivingAllowanceInfoBottomSheet extends StatelessWidget {
  const GivingAllowanceInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              locals.createChildGivingAllowanceTitle,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 15),
            Text(
              locals.createChildGivingAllowanceText,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
