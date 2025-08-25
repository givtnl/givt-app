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
    this.tooltipHorizontalPosition = TooltipHorizontalPosition.CENTER,
    this.tooltipVerticalPosition = TooltipVerticalPosition.TOP,
    this.triangleOffset = Offset.zero,
    this.buttonBottomRightOverride,
    this.analyticsEventButtonOverride,
    this.showButton = true,
    this.showImage = true,
    this.imageLeft,
    this.buttonIcon,
    this.analyticsEvent,
    this.onButtonTap,
    this.onHighlightedWidgetTap,
    this.dropShadow = false,
    this.enableTapToDismiss = false,
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

  // Callback when the user taps the widget that is highlighted by the tooltip
  final VoidCallback? onHighlightedWidgetTap;

  // Overrides the default button icon
  final Widget? buttonIcon;

  // Overrides the default analytics event
  final AmplitudeEvents? analyticsEvent;

  // Replaced the default button with a custom one
  final Widget? buttonBottomRightOverride;

  final bool dropShadow;
  final bool enableTapToDismiss;

  final Widget child;

  static const horizontalPadding = 24.0;
  static const triangleHeight = 23.0;

  @override
  Widget build(BuildContext context) {
    return OverlayTooltipItem(
      displayIndex: tooltipIndex,
      tooltipHorizontalPosition: tooltipHorizontalPosition,
      tooltipVerticalPosition: tooltipVerticalPosition,
      onHighlightedWidgetTap: onHighlightedWidgetTap,
      tooltip: (TooltipController controller) {
        final width = MediaQuery.of(context).size.width;
        return Theme(
          data: const FamilyAppTheme().toThemeData(),
          child: Tooltip(
            enableTapToDismiss: enableTapToDismiss,
            message: title,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 12,
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: dropShadow
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tooltipVerticalPosition ==
                        TooltipVerticalPosition.BOTTOM)
                      _bubbleTriangle(),
                    Container(
                      width: width - (horizontalPadding * 2),
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 16,
                        right: 16,
                        bottom: 12,
                      ),
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
                                if(labelBottomLeft.isNotEmpty || showButton)
                                Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (labelBottomLeft.isNotEmpty)
                                          LabelMediumText(
                                            labelBottomLeft,
                                          ),
                                        Opacity(
                                          opacity: showButton ? 1 : 0,
                                          child: Semantics(
                                            identifier:
                                                'tooltipNext$tooltipIndex',
                                            label: 'tooltipNext$tooltipIndex',
                                            child: buttonBottomRightOverride ??
                                                CustomIconBorderButton(
                                                  key: ValueKey(
                                                    'tooltipNext$tooltipIndex',
                                                  ),
                                                  onTap: onButtonTap ??
                                                      () => controller.next(),
                                                  analyticsEvent:
                                                      analyticsEventButtonOverride ??
                                                          (analyticsEvent ??
                                                              AmplitudeEvents
                                                                  .tutorialNextClicked)
                                                              .toEvent(
                                                            parameters: {
                                                              'tutorialLabelBottomLeft':
                                                                  labelBottomLeft,
                                                              'tutorialTitle':
                                                                  title,
                                                              'tutorialDescription':
                                                                  description,
                                                            },
                                                          ),
                                                  child: buttonIcon ??
                                                      const FaIcon(
                                                        FontAwesomeIcons
                                                            .arrowRight,
                                                      ),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (tooltipVerticalPosition == TooltipVerticalPosition.TOP)
                      _bubbleTriangle(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }

  CustomPaint _bubbleTriangle() {
    return CustomPaint(
      painter: TrianglePainter(
        strokeColor: Colors.white,
        paintingStyle: PaintingStyle.fill,
        offset: triangleOffset,
        direction: tooltipVerticalPosition == TooltipVerticalPosition.TOP
            ? TriangleDirection.down
            : TriangleDirection.up,
      ),
      child: const SizedBox(
        height: triangleHeight,
        width: 18,
      ),
    );
  }
}
