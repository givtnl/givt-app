import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      ? 'assets/images/family_avatar.svg'
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
                          ? context.l10n.theFamilyWithName(impactGroup.name)
                          : impactGroup.organiser.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.mulish(
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${context.l10n.goal}: \$${impactGroup.goal.goalAmount}',
                          style: GoogleFonts.mulish(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (!impactGroup.isFamilyGroup)
                          Text(
                            ' · ',
                            style: GoogleFonts.mulish(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        if (!impactGroup.isFamilyGroup)
                          Text(
                            '${impactGroup.amountOfMembers} ${context.l10n.members}',
                            style: GoogleFonts.mulish(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
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
