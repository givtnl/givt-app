import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class GameProfileItem extends StatelessWidget {
  const GameProfileItem({
    required this.profile,
    this.displayName = true,
    this.displayRole = true,
    this.size = 80,
    this.accentColor,
    super.key,
  });

  final GameProfile profile;
  final bool displayName;
  final bool displayRole;
  final double size;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size + 16,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor ??
                        profile.role?.color.accentColor ??
                        Colors.red,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: FunAvatar.fromGameProfile(
                      profile,
                      size: size - 12,
                    ),
                  ),
                ),
              ),
              if (displayRole)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: profile.roles.length == 2
                      ? SizedBox(
                          height: 36,
                          width: (36 * 2) - 4,
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                child: _icon(profile.roles[1]),
                              ),
                              Positioned(
                                left: 0,
                                child: _icon(profile.roles[0]),
                              ),
                            ],
                          ),
                        )
                      : _iconRow(),
                ),
            ],
          ),
        ),
        if (displayName && displayRole) const SizedBox(height: 8),
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

  Row _iconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        profile.roles.length,
        (i) => _icon(profile.roles[i]),
      ),
    );
  }

  Container _icon(Role role) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accentColor ?? role.color.accentColor,
      ),
      child: Icon(
        _getIconPerRole(role),
        size: 16,
        color: FamilyAppTheme.primary20,
      ),
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
