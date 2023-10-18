import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class VPCNoticeDialog extends StatelessWidget {
  const VPCNoticeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          context.l10n.directNoticeText,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
