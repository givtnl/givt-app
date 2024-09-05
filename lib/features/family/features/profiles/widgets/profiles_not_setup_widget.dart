import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/features/auth/helpers/logout_helper.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class ProfilesNotSetupWidget extends StatelessWidget {
  const ProfilesNotSetupWidget({
    required this.onSetupClicked,
    super.key,
  });

  final void Function() onSetupClicked;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BodyMediumText(
              'Your family has not been setup yet!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: FunSecondaryButton(
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
                  child: FunButton(
                    onTap: onSetupClicked,
                    text: 'Setup my Family',
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
