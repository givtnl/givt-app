import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/utils/utils.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // Width - 2*24 (side padding) - 2*20 (item padding) / 3 (items in a row)
    var imgSize = (MediaQuery.of(context).size.width - 24 * 2 - 20 * 2) / 3;

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SvgPicture.network(
            imageUrl,
            width: imgSize,
            height: imgSize,
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.defaultTextColor),
          ),
        ],
      ),
    );
  }
}
