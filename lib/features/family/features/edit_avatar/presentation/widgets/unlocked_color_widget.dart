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
  final Function(int index, String type, {Color? color}) onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: FunIcon(
        circleSize: size,
        iconSize: size,
        circleColor:
            uiModel.isSelected ? FamilyAppTheme.primary80 : Colors.transparent,
        icon: Container(
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
        ),
      ),
    );
  }
}
