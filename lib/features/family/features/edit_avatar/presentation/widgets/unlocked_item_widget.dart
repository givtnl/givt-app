import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_item_uimodel.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class UnlockedItemWidget extends StatelessWidget {
  const UnlockedItemWidget({
    required this.uiModel,
    required this.onPressed,
    super.key,
  });

  final UnlockedItem uiModel;
  final void Function(int index, String type) onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      isPressedDown: uiModel.isSelected,
      borderColor: uiModel.isSelected
          ? FamilyAppTheme.primary80
          : FamilyAppTheme.neutralVariant80,
      onTap: () => onPressed(uiModel.index, uiModel.type),
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.unlockedAvatarItemClicked,
        parameters: {
          'type': uiModel.type,
          'index': uiModel.index,
        },
      ),
      child: ColoredBox(
        color: uiModel.isSelected
            ? FamilyAppTheme.primary98
            : FamilyAppTheme.neutral100,
        child: Center(
          child: SvgPicture.asset(
            'assets/family/images/avatar/custom/tiles/Tile${uiModel.type}${uiModel.index}.svg',
            errorBuilder: (context, error, stackTrace) => const FaIcon(
              FontAwesomeIcons.lock,
              color: FamilyAppTheme.neutralVariant60,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
