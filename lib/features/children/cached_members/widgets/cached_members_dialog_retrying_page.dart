import 'package:flutter/material.dart';

class CachedMembersDialogRetryingPage extends StatelessWidget {
  const CachedMembersDialogRetryingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator.adaptive(),
          SizedBox(height: 16),
          Text(
            //TODO: POEditor
            'Trying to collect funds...',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
