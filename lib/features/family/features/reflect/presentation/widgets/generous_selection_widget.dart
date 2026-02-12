import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/gratitude_selection_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GenerousSelectionWidget extends StatelessWidget {
  const GenerousSelectionWidget({
    required this.uimodel,
    required this.onClickTile,
    required this.onNext,
    super.key,
  });

  final TagSelectionUimodel uimodel;
  final void Function(TagCategory? gratitude) onClickTile;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      appBar: const FunTopAppBar(
        title: 'Question 4',
        actions: [
          LeaveGameButton(),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          const BodyMediumText(
            'Ask the superhero and pick one',
            color: FamilyAppTheme.primary30,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const TitleMediumText(
            'In what way have you\nbeen generous today?',
            color: FamilyAppTheme.primary30,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          LayoutGrid(
            columnSizes: [1.fr, 1.fr],
            rowSizes: const [
              auto,
              auto,
              auto,
              auto,
            ],
            columnGap: 16,
            rowGap: 16,
            children: [
              for (int i = 0; i < uimodel.tagList.length; i++)
                FunTile(
                  shrink: true,
                  titleBig: uimodel.tagList[i].title,
                  titleMedium: uimodel.tagList[i].displayText,
                  assetSize: 27,
                  iconPath: '',
                  iconData: uimodel.tagList[i].iconData,
                  iconColor: uimodel.tagList[i].colorCombo.darkColor,
                  onTap: () {
                    onClickTile(uimodel.tagList[i]);
                  },
                  isSelected: uimodel.selectedTag == uimodel.tagList[i],
                  borderColor: uimodel.tagList[i].colorCombo.borderColor,
                  backgroundColor:
                      uimodel.tagList[i].colorCombo.backgroundColor,
                  textColor: uimodel.tagList[i].colorCombo.textColor,
                  analyticsEvent: AmplitudeEvents.generousTileSelected.toEvent(
                    parameters: {
                      'generousPower': uimodel.selectedTag?.title,
                    },
                  ),
                ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: FunButton(
              isDisabled: uimodel.selectedTag == null,
              onTap: onNext,
              text: 'Next',
              analyticsEvent: AmplitudeEvents.generousTileSubmitted.toEvent(
                parameters: {
                  'superhero': uimodel.superheroName,
                  'haveBeenGenerous': uimodel.selectedTag?.displayText,
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
