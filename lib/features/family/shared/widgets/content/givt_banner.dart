import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class GivtBanner extends StatelessWidget {
  const GivtBanner({
    required this.badgeImage,
    required this.title,
    required this.content,
    super.key,
  });

  final String badgeImage;
  final String title;
  final String content;

  static const double _dropShadowHeight = 6;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: FamilyAppTheme.highlight80,
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: _dropShadowHeight),
      child: Container(
        width: double.maxFinite,
        height: 128,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: FamilyAppTheme.highlight95,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              badgeImage,
              width: 80,
              height: 80,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelMediumText(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  color: FamilyAppTheme.highlight40,
                ),
                TitleMediumText(
                  content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  color: FamilyAppTheme.highlight30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
