import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/utils/utils.dart';

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
            color: AppTheme.highlight80,
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
          color: AppTheme.highlight95,
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
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.highlight40,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.highlight40,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
