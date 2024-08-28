import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

class GameProfileItem extends StatelessWidget {
  const GameProfileItem({
    required this.profile,
    super.key,
  });

  final GameProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: profile.role?.color,
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
}
