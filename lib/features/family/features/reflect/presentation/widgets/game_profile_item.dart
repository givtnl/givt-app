import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class GameProfileItem extends StatelessWidget {
  const GameProfileItem({
    required this.profile,
    super.key,
  });

  final GameProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: profile.role?.color ?? Colors.red,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: SvgPicture.network(
                    profile.pictureURL!,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 180,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: profile.role?.color ?? Colors.red,
                  ),
                  child: Icon(
                    _getIconPerRole(),
                    color: FamilyAppTheme.primary20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          profile.firstName!,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  IconData _getIconPerRole() {
    switch (profile.role.runtimeType) {
      case SuperHero:
        return FontAwesomeIcons.mask;
      case Sidekick:
        return FontAwesomeIcons.solidHandshake;
      case Reporter:
      default:
        return FontAwesomeIcons.microphone;
    }
  }
}
