import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/gratitude_selection_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GratitudeSelectionWidget extends StatelessWidget {
  const GratitudeSelectionWidget({
    required this.uimodel,
    required this.onClickTile,
    required this.onNext,
    super.key,
  });

  final GratitudeSelectionUimodel uimodel;
  final void Function(GratitudeCategory? gratitude) onClickTile;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      appBar: const FunTopAppBar(
        title: 'Question 3',
        actions: [
          LeaveGameButton(),
        ],
      ),
      body: Column(
        children: [
          const BodyMediumText(
            'Ask the superhero and pick one',
            color: FamilyAppTheme.primary30,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const TitleMediumText(
            'What are you grateful for today?',
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
              for (int i = 0; i < uimodel.gratitudeList.length; i++)
                FunTile(
                  shrink: true,
                  titleMedium: uimodel.gratitudeList[i].displayText,
                  assetSize: 27,
                  iconPath: '',
                  iconData: uimodel.gratitudeList[i].iconData,
                  iconColor: uimodel.gratitudeList[i].colorCombo.darkColor,
                  onTap: () {
                    onClickTile(uimodel.gratitudeList[i]);
                  },
                  isSelected:
                      uimodel.selectedGratitude == uimodel.gratitudeList[i],
                  borderColor: uimodel.gratitudeList[i].colorCombo.borderColor,
                  backgroundColor:
                      uimodel.gratitudeList[i].colorCombo.backgroundColor,
                  textColor: uimodel.gratitudeList[i].colorCombo.textColor,
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.gratefulTileSelected,
                    parameters: {
                      'gratefulFor': uimodel.selectedGratitude?.displayText,
                    },
                  ),
                ),
            ],
          ),
          const Spacer(),
          FunButton(
            isDisabled: uimodel.selectedGratitude == null,
            onTap: onNext,
            text: 'Last question',
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.gratefulTileSubmitted,
              parameters: {
                'superhero': uimodel.superheroName,
                'gratefulFor': uimodel.selectedGratitude?.displayText,
              },
            ),
          ),
        ],
      ),
    );
  }
}
