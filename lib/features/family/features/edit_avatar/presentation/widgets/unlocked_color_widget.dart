import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_item_uimodel.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/utils/utils.dart';

class UnlockedColorWidget extends StatelessWidget {
  const UnlockedColorWidget({
    required this.color,
    required this.uiModel,
    required this.onPressed,
    this.size = 54,
    super.key,
  });

  final Color color;
  final UnlockedItem uiModel;
  final double size;
  final void Function(int index, String type, {Color? color}) onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main color button
        FunIcon(
          circleSize: size,
          iconSize: size,
          circleColor: uiModel.isSelected ? FamilyAppTheme.primary80 : Colors.transparent,
          icon: GestureDetector(
            onTap: () {
              onPressed.call(uiModel.index, uiModel.type, color: color);
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.unlockedAvatarItemClicked,
                eventProperties: {
                  'type': uiModel.type,
                  'index': uiModel.index,
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: uiModel.isSelected
                      ? FamilyAppTheme.primary80
                      : Colors.transparent,
                  width: 4,
                ),
                color: color,
                shape: BoxShape.circle,
              ),
              height: size,
              width: size,
              // Easter egg badge positioned inside the container
              child: uiModel.isEasterEgg
                  ? Stack(
                      children: [
                        Positioned(
                          top: -2,
                          right: -2,
                          child: _buildEasterEggBanner(),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEasterEggBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: const BoxDecoration(
        color: FamilyAppTheme.tertiary80,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: const Text(
        '🥚',
        style: TextStyle(fontSize: 10),
      ),
    );
  }
}
