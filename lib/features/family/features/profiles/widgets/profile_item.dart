import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    required this.name,
    required this.imageUrl,
    super.key,
  });

  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.network(
          imageUrl,
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 12),
        Text(
          name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
