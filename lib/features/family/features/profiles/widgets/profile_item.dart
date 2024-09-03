import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    required this.name,
    this.imageUrl,
    this.assetImage,
    super.key,
  });

  final String name;
  final String? imageUrl;
  final String? assetImage;

  @override
  Widget build(BuildContext context) {
    final imgSize = (MediaQuery.of(context).size.width - 24 * 2 - 20 * 2) / 3;

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          if (assetImage != null)
            SvgPicture.asset(
              assetImage!,
              width: imgSize,
              height: imgSize,
            ),
          if (imageUrl != null)
            SvgPicture.network(
              imageUrl!,
              width: imgSize,
              height: imgSize,
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              const SizedBox(width: 4),
              const FaIcon(
                FontAwesomeIcons.arrowRight,
                color: FamilyAppTheme.defaultTextColor,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
