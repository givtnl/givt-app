import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/featured_collect_group.dart';

/// Suggestion card for the featured door-to-door collect group on For You.
///
/// Figma: Ongoing Designs `55439:470478` — accent Card + "This week" FunTag.
class DoorToDoorSuggestionCard extends StatelessWidget {
  const DoorToDoorSuggestionCard({
    required this.featured,
    required this.organisation,
    required this.onTap,
    super.key,
  });

  final FeaturedCollectGroup featured;
  final CollectGroup organisation;
  final VoidCallback onTap;

  static const double _tagOverlap = 12;
  static const double _illustrationSize = 32;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final locals = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: _tagOverlap),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onTap,
                child: Ink(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.tertiary98,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.tertiary90,
                      width: theme.borderWidthThinner,
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildIllustration(context, theme),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LabelMediumText(
                              organisation.orgName,
                              color: theme.tertiary10,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                        width: double.infinity,
                        child: Center(
                          child: Container(
                            height: 1,
                            color: theme.tertiary90,
                          ),
                        ),
                      ),
                      BodySmallText(
                        locals.doorToDoorSuggestionSubtitle,
                        color: theme.tertiary20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: FunTag(
                text: locals.doorToDoorSuggestionTag,
                variant: FunTagVariant.accent,
                margin: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(BuildContext context, FunAppTheme theme) {
    final logoUrl = featured.logoUrl.trim();
    if (logoUrl.startsWith('http')) {
      final isSvg = logoUrl.toLowerCase().contains('.svg');
      return SizedBox(
        width: _illustrationSize,
        height: _illustrationSize,
        child: ClipOval(
          child: isSvg
              ? SvgPicture.network(
                  logoUrl,
                  fit: BoxFit.cover,
                  width: _illustrationSize,
                  height: _illustrationSize,
                  placeholderBuilder: (_) => _doorOpenIcon(theme),
                )
              : Image.network(
                  logoUrl,
                  fit: BoxFit.cover,
                  width: _illustrationSize,
                  height: _illustrationSize,
                  errorBuilder: (_, _, _) => _doorOpenIcon(theme),
                ),
        ),
      );
    }
    return _doorOpenIcon(theme);
  }

  Widget _doorOpenIcon(FunAppTheme theme) {
    return SizedBox(
      width: _illustrationSize,
      height: _illustrationSize,
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.doorOpen,
          size: 16,
          color: theme.tertiary10,
        ),
      ),
    );
  }
}
