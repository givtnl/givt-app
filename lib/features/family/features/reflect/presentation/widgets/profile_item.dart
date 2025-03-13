import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    required this.profile,
    this.size = 80,
    super.key,
  });

  final GameProfile profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Draggable<GameProfile>(
      data: profile,
      childWhenDragging: SizedBox(
        width: size,
        height: size,
      ),
      feedback: _feedbackCircle(size),
      child: Column(
        children: [
          Semantics(
            identifier: profile.pictureURL?.split('/').last,
            child: SvgPicture.network(
              profile.pictureURL!,
              width: size,
              height: size,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: size,
            child: Text(
              profile.firstName!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }

  Container _feedbackCircle(double width) {
    return Container(
      height: width,
      width: width,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: FamilyAppTheme.primary20,
      ),
      child: Semantics(
        identifier: profile.pictureURL?.split('/').last,
        child: SvgPicture.network(
          profile.pictureURL!,
          width: width,
          height: width,
        ),
      ),
    );
  }
}
