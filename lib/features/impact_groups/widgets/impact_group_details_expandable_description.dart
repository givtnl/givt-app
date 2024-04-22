import 'package:flutter/material.dart';
import 'package:givt_app/features/impact_groups/dialogs/impact_group_details_description_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

class ImpactGroupDetailsExpandableDescription extends StatelessWidget {
  const ImpactGroupDetailsExpandableDescription({
    required this.description,
    super.key,
  });

  final String description;

  int _calculateLinesNumber(String text, TextStyle style, double maxWidth) {
    final textSpan = TextSpan(text: description, style: style);
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr)
          ..layout(maxWidth: maxWidth);
    return textPainter.computeLineMetrics().length;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.mulish(
      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final numLines = _calculateLinesNumber(
            description,
            textStyle,
            constraints.maxWidth,
          );

          if (numLines > 2) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                TextButton(
                  onPressed: () {
                    ImpactGroupDetailsDescriptionDialog
                        .showImpactGroupDescriptionDialog(
                      context: context,
                      description: description,
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                  ),
                  child: Text(
                    context.l10n.featureReadMore,
                    style: textStyle.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Text(description, style: textStyle);
          }
        },
      ),
    );
  }
}
