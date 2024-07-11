import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/features/auth/helpers/logout_helper.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_elevated_secondary_button.dart';

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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'There are no profiles attached to the current user.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: GivtElevatedSecondaryButton(
                    onTap: () => logout(context, fromLogoutBtn: true),
                    text: 'Logout',
                    leftIcon: SvgPicture.asset(
                      'assets/family/images/logout.svg',
                      width: 36,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: GivtElevatedButton(
                    onTap: onRetry,
                    text: 'Retry',
                    leftIcon: Icons.refresh_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
