import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/content/triangle_painter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/buttons/custom_icon_border_button.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class FunTooltip extends StatelessWidget {
  const FunTooltip({
    required this.tooltipIndex,
    required this.title,
    required this.description,
    required this.labelBottomLeft,
    required this.child,
    super.key,
    this.tooltipHorizontalPosition = TooltipHorizontalPosition.WITH_WIDGET,
    this.tooltipVerticalPosition = TooltipVerticalPosition.TOP,
    this.triangleOffset = Offset.zero,
    this.buttonBottomRightOverride,
    this.analyticsEventButtonOverride,
    this.showButton = true,
    this.showImage = true,
    this.imageLeft,
    this.buttonIcon,
    this.onButtonTap,
  });

  final int tooltipIndex;
  final TooltipHorizontalPosition tooltipHorizontalPosition;
  final TooltipVerticalPosition tooltipVerticalPosition;

  final String title;
  final String description;
  final String labelBottomLeft;

  final bool showImage;
  final Widget? imageLeft;

  // Displaces the triangle position with the given offset
  final Offset triangleOffset;

  final bool showButton;

  // Overrides the default button analytics event
  final AnalyticsEvent? analyticsEventButtonOverride;

  // Overrides the default button tap action
  final VoidCallback? onButtonTap;

  // Overrides the default button icon
  final Widget? buttonIcon;

  // Replaced the default button with a custom one
  final Widget? buttonBottomRightOverride;

  final Widget child;

  static const horizontalPadding = 24.0;
  static const triangleHeight = 23.0;

  @override
  Widget build(BuildContext context) {
    return OverlayTooltipItem(
      displayIndex: tooltipIndex,
      tooltipHorizontalPosition: tooltipHorizontalPosition,
      tooltipVerticalPosition: tooltipVerticalPosition,
      tooltip: (TooltipController controller) {
        final width = MediaQuery.of(context).size.width;
        return Tooltip(
          message: title,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 12,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width - (horizontalPadding * 2),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showImage) imageLeft ?? FunAvatar.captain(),
                          if (showImage) const SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TitleSmallText(
                                  title,
                                  color: FamilyAppTheme.secondary30,
                                  textAlign: TextAlign.start,
                                ),
                                BodySmallText(
                                  description,
                                  color: FamilyAppTheme.secondary30,
                                ),
                                const SizedBox(height: 12),
                                LabelMediumText(
                                  labelBottomLeft,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomPaint(
                      painter: TrianglePainter(
                        strokeColor: Colors.white,
                        paintingStyle: PaintingStyle.fill,
                        offset: triangleOffset,
                      ),
                      child: const SizedBox(
                        height: triangleHeight,
                        width: 18,
                      ),
                    ),
                  ],
                ),
                if (showButton)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12 + triangleHeight,
                        right: 16,
                      ),
                      child: buttonBottomRightOverride ??
                          CustomIconBorderButton(
                            onTap: onButtonTap ?? () => controller.next(),
                            analyticsEvent: analyticsEventButtonOverride ??
                                AnalyticsEvent(
                                  AmplitudeEvents.tutorialNextClicked,
                                  parameters: {
                                    'tutorialLabelBottomLeft': labelBottomLeft,
                                    'tutorialTitle': title,
                                    'tutorialDescription': description,
                                  },
                                ),
                            child: buttonIcon ??
                                const FaIcon(
                                  FontAwesomeIcons.arrowRight,
                                ),
                          ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      child: child,
    );
  }
}
