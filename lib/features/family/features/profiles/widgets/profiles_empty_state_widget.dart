import 'package:flutter/material.dart';
import 'package:givt_app/utils/utils.dart';

class ProfilesEmptyStateWidget extends StatelessWidget {
  const ProfilesEmptyStateWidget({
    required this.onRetry,
    super.key,
  });

  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'There are no profiles attached to the current user.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.givt4KidsBlue,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
