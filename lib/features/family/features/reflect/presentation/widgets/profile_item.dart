import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    required this.profile,
    super.key,
  });

  final GameProfile profile;

  @override
  Widget build(BuildContext context) {
    return Draggable<GameProfile>(
      data: profile,
      childWhenDragging: const SizedBox(
        width: 80,
        height: 80,
      ),
      feedback: _feedbackCircle(80),
      child: Column(
        children: [
          SvgPicture.network(
            profile.pictureURL!,
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 12),
          Container(
            width: 80,
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
      child: SvgPicture.network(
        profile.pictureURL!,
        width: 80,
        height: 80,
      ),
    );
  }
}
