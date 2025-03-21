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
    super.key,
  });

  final Color color;
  final UnlockedItem uiModel;
  final Function(int index, String type) onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed.call(uiModel.index, uiModel.type);
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.unlockedAvatarItemClicked,
          eventProperties: {
            'type': uiModel.type,
            'index': uiModel.index,
          },
        );
      },
      child: FunIcon(
        circleSize: 54,
        iconSize: 54,
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
          height: 54,
          width: 54,
        ),
      ),
    );
  }
}
