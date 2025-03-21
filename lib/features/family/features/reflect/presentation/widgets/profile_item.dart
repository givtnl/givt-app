import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';

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
          FunAvatar.hero(profile.avatar!, size: size),
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

  Widget _feedbackCircle(double size) {
    return SizedBox(
      height: size,
      width: size,
      child: FunAvatar.hero(
        profile.avatar!,
        size: size,
      ),
    );
  }
}
