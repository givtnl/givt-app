import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/features/impact_groups/model/impact_group.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class ImpactGroupDetailsHeader extends StatelessWidget {
  const ImpactGroupDetailsHeader({
    required this.impactGroup,
    super.key,
  });

  final ImpactGroup impactGroup;

  Widget _createPicture({
    required String path,
    double? width,
    double? height,
    bool isAsset = true,
  }) {
    return isAsset
        ? SvgPicture.asset(path, width: width, height: height)
        : SvgPicture.network(path, width: width, height: height);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (impactGroup.isFamilyGroup)
          const SizedBox(height: 30)
        else
          Image.network(impactGroup.image),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Transform.translate(
                offset: const Offset(0, -6),
                child: _createPicture(
                  path: impactGroup.isFamilyGroup
                      ? 'assets/family/images/family_avatar.svg'
                      : impactGroup.organiser.avatar,
                  width: 70,
                  height: 70,
                  isAsset: impactGroup.isFamilyGroup,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      impactGroup.isFamilyGroup
                          ? 'The ${impactGroup.name}'
                          : impactGroup.organiser.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Goal: \$${impactGroup.goal.goalAmount}',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: FamilyAppTheme.primary50,
                                  ),
                        ),
                        if (!impactGroup.isFamilyGroup)
                          Text(
                            ' · ',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: FamilyAppTheme.neutralVariant60,
                                ),
                          ),
                        if (!impactGroup.isFamilyGroup)
                          Text(
                            '${impactGroup.amountOfMembers} members',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: FamilyAppTheme.tertiary50,
                                ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
