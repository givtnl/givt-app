import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class CachedMembersDialogRetryingPage extends StatelessWidget {
  const CachedMembersDialogRetryingPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 16),
          Text(
            context.l10n.vpcNoFundsTrying,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
