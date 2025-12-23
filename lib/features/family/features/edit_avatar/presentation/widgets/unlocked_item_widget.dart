import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_item_uimodel.dart';
import 'package:givt_app/features/family/helpers/helpers.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class UnlockedItemWidget extends StatelessWidget {
  const UnlockedItemWidget({
    required this.uiModel,
    required this.onPressed,
    this.recolor,
    this.useSecondLongestPath = false,
    this.replacePlaceholders = false,
    super.key,
  });

  final UnlockedItem uiModel;
  final Color? recolor;
  final bool useSecondLongestPath;
  final bool replacePlaceholders;
  final void Function(int index, String type) onPressed;

  @override
  Widget build(BuildContext context) {
    final path =
        'assets/family/images/avatar/custom/tiles/Tile${uiModel.type}${uiModel.index}.svg';
    return ActionContainer(
      isPressedDown: uiModel.isSelected,
      borderColor: uiModel.isSelected
          ? FamilyAppTheme.primary80
          : FamilyAppTheme.neutralVariant80,
      onTap: () => onPressed(uiModel.index, uiModel.type),
      analyticsEvent: AnalyticsEventName.unlockedAvatarItemClicked.toEvent(
        parameters: {
          'type': uiModel.type,
          'index': uiModel.index.toString(),
        },
      ),
      child: Stack(
        children: [
          ColoredBox(
            color: uiModel.isSelected
                ? FamilyAppTheme.primary98
                : FamilyAppTheme.neutral100,
            child: Center(
              child: recolor != null
                  ? FutureBuilder(
                      future: replacePlaceholders
                          ? recolorPlaceholdersSvgFromAsset(
                              path,
                              color: recolor!,
                            )
                          : recolorSvgFromAsset(
                              path,
                              color: recolor!,
                              useSecondLongestPath: useSecondLongestPath,
                            ),
                      builder:
                          (
                            BuildContext context,
                            AsyncSnapshot<String> snapshot,
                          ) {
                            return snapshot.data != null
                                ? SvgPicture.string(
                                    snapshot.data!,
                                  )
                                : _regularSvg(path);
                          },
                    )
                  : _regularSvg(path),
            ),
          ),
          if (uiModel.isEasterEgg)
            Positioned(
              top: 0,
              right: 0,
              child: _buildEasterEggBanner(),
            ),
        ],
      ),
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

  SvgPicture _regularSvg(String path) {
    return SvgPicture.asset(
      path,
      errorBuilder: (context, error, stackTrace) => const FaIcon(
        FontAwesomeIcons.lock,
        color: FamilyAppTheme.neutralVariant60,
        size: 32,
      ),
    );
  }
}
