import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class GameProfileItem extends StatelessWidget {
  const GameProfileItem({
    required this.profile,
    this.displayName = true,
    this.size = 80,
    super.key,
  });

  final GameProfile profile;
  final bool displayName;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size + 20,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
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
                      width: size,
                      height: size,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(
                    profile.roles.length,
                    (i) => Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: profile.roles[i].color,
                      ),
                      child: Icon(
                        _getIconPerRole(profile.roles[i]),
                        color: FamilyAppTheme.primary20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (displayName) const SizedBox(height: 12),
        if (displayName)
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

  IconData _getIconPerRole(Role? role) {
    switch (role.runtimeType) {
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
