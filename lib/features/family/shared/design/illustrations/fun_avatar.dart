import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/custom_avatar_uimodel.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunAvatar extends FunIcon {
  const FunAvatar({
    required this.semanticsIdentifier,
    super.key,
    this.customCircleColor = FamilyAppTheme.primary95,
    this.customAvatar = const SizedBox(),
    this.customSize = 48,
  });

  factory FunAvatar.captain({bool isLarge = false, bool lookRight = false}) {
    return FunAvatar(
      semanticsIdentifier: 'captain',
      customCircleColor: FamilyAppTheme.neutral95,
      customAvatar: Transform(
        alignment: Alignment.center,
        transform: lookRight ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
        child: SvgPicture.asset(
          isLarge
              ? 'assets/family/images/avatar_captain_large.svg'
              : 'assets/family/images/avatar_captain.svg',
        ),
      ),
      customSize: isLarge ? 140 : 48,
    );
  }

  factory FunAvatar.captainAi({bool withBorder = false, bool isLarge = false}) {
    return FunAvatar(
      semanticsIdentifier: 'captainAi',
      customCircleColor: FamilyAppTheme.neutral95,
      customAvatar: Image.asset(
        withBorder
            ? 'assets/family/images/beta_captain_with_border.webp'
            : 'assets/family/images/beta_captain.webp',
      ),
      customSize: isLarge ? 160 : 50,
    );
  }

  factory FunAvatar.family({bool isLarge = false}) {
    return FunAvatar(
      semanticsIdentifier: 'family',
      customCircleColor: FamilyAppTheme.neutral95,
      customAvatar: SvgPicture.asset('assets/family/images/family_avatar.svg'),
      customSize: isLarge ? 120 : 48,
    );
  }

  factory FunAvatar.fromProfile(Profile profile, {double size = 120}) {
    if (profile.customAvatar != null) {
      return FunAvatar.custom(profile.customAvatar!.toUIModel(), size: size);
    } else if (profile.avatar != null) {
      return FunAvatar.hero(profile.avatar!, size: size);
    } else {
      return FunAvatar.hero('Hero1.svg', size: size);
    }
  }

  factory FunAvatar.custom(CustomAvatarUIModel uiModel, {double size = 120}) {
    return FunAvatar(
      semanticsIdentifier: uiModel.semanticsIdentifier,
      customCircleColor: FamilyAppTheme.info95,
      customAvatar: ClipOval(
        child: Padding(
          padding: EdgeInsets.only(
            top: size / 15,
          ), // Add 8px padding above the SVG
          child: Stack(
            children: List.generate(
              uiModel.assetsToOverlap.length,
              (index) => SvgPicture.asset(
                uiModel.assetsToOverlap[index],
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
      ),
      customSize: size,
    );
  }

  factory FunAvatar.defaultHero({double size = 120}) {
    return FunAvatar.hero('Hero1.svg', size: size);
  }

  factory FunAvatar.hero(String heroName, {double size = 120}) {
    return FunAvatar(
      semanticsIdentifier: heroName,
      customCircleColor: FamilyAppTheme.info95,
      customAvatar: ClipOval(
        child: Padding(
          padding: EdgeInsets.only(
            top: size / 15,
          ), // Add 8px padding above the SVG
          child: SvgPicture.asset(
            'assets/family/images/avatar/default/$heroName',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
              'assets/family/images/avatar/default/Hero1.svg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
      ),
      customSize: size,
    );
  }

  final String semanticsIdentifier;
  final Color customCircleColor;
  final Widget customAvatar;
  final double customSize;

  @override
  Widget build(BuildContext context) {
    return FunIcon(
      icon: customAvatar,
      semanticsIdentifier: semanticsIdentifier,
      padding: EdgeInsets.zero,
      circleColor: customCircleColor,
      circleSize: customSize,
    );
  }
}
