import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameProfileItem extends StatelessWidget {
  const GameProfileItem({
    required this.name,
    required this.imageUrl,
    this.borderColor,
    super.key,
  });

  final String name;
  final String imageUrl;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: borderColor,
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: SvgPicture.network(
              imageUrl,
              width: 80,
              height: 80,
            ),
          ),
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
