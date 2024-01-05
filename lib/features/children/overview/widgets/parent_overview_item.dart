import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/utils/utils.dart';

class ParentOverviewItem extends StatelessWidget {
  const ParentOverviewItem({
    required this.profile,
    super.key,
  });

  final Profile profile;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SvgPicture.network(
              profile.pictureURL,
              width: 48,
              height: 48,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            profile.firstName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  color: AppTheme.givtBlue,
                ),
          ),
        ],
      ),
    );
  }
}
