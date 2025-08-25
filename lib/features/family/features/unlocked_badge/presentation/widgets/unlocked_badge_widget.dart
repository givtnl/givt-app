import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/unlocked_badge/cubit/unlocked_badge_cubit.dart';
import 'package:givt_app/features/family/features/unlocked_badge/presentation/models/unlocked_badge_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class UnlockedBadgeWidget extends StatefulWidget {
  const UnlockedBadgeWidget({
    required this.featureId,
    this.profileId,
    this.offset = 0,
    this.child,
    this.position = BadgePosition.topRight,
    super.key,
  });

  final double offset;
  final Widget? child;
  final String? featureId;
  final String? profileId;
  final BadgePosition position;

  @override
  State<UnlockedBadgeWidget> createState() => _UnlockedBadgeWidgetState();
}

class _UnlockedBadgeWidgetState extends State<UnlockedBadgeWidget> {
  final UnlockedBadgeCubit _cubit = getIt<UnlockedBadgeCubit>();

  @override
  void initState() {
    super.initState();

    // Initializing is only needed when a featureId is provided,
    // otherwise we don't show a badge
    if (widget.featureId != null && widget.profileId != null) {
      _cubit.init(widget.featureId!, widget.profileId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onInitial: (context) => widget.child ?? const SizedBox.shrink(),
      onData: (context, uiModel) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerUp: (_) => _cubit.markFeatureAsSeen(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            widget.child ?? const SizedBox.shrink(),
            if (uiModel.showBadge)
              if (widget.child != null)
                Positioned(
                  top: widget.position == BadgePosition.topRight ||
                          widget.position == BadgePosition.topLeft
                      ? (0 - widget.offset)
                      : null,
                  right: widget.position == BadgePosition.topRight ||
                          widget.position == BadgePosition.bottomRight
                      ? (0 - widget.offset)
                      : null,
                  bottom: widget.position == BadgePosition.bottomRight ||
                          widget.position == BadgePosition.bottomLeft
                      ? (0 + widget.offset)
                      : null,
                  left: widget.position == BadgePosition.topLeft ||
                          widget.position == BadgePosition.bottomLeft
                      ? (0 + widget.offset)
                      : null,
                  child: _showBadge(uiModel),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: _showBadge(uiModel),
                ),
          ],
        ),
      ),
    );
  }

  bool shouldShowNumber(UnlockedBadgeUIModel uiModel) => uiModel.count > 1;

  Widget _showBadge(UnlockedBadgeUIModel uiModel) {
    final showNumber = shouldShowNumber(uiModel);
    return Container(
      alignment: Alignment.center,
      width: showNumber ? 16 : 12,
      height: showNumber ? 16 : 12,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: showNumber
          ? LabelBadgeText(
              uiModel.count.toString(),
              color: Colors.white,
              textAlign: TextAlign.center,
            )
          : null,
    );
  }
}

enum BadgePosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}
