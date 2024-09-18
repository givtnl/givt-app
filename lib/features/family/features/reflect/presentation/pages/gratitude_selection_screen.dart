import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/gratitude_selection_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GratitudeSelectionScreen extends StatelessWidget {
  const GratitudeSelectionScreen(
      {required this.uimodel,
      required this.onClickTile,
      required this.onNext,
      super.key});
  final GratitudeSelectionUimodel uimodel;
  final void Function(GratitudeCategory? gratitude) onClickTile;
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: FunTopAppBar.primary99(title: 'Gratitude'),
      body: Column(
        children: [
          const TitleLargeText(
            'What was the superhero grateful for?',
            color: FamilyAppTheme.primary30,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const BodyMediumText('Choose one thats fits the best'),
          const SizedBox(height: 24),
          LayoutGrid(
            columnSizes: [1.fr, 1.fr],
            rowSizes: [
              90.px,
              90.px,
              90.px,
            ],
            columnGap: 16,
            rowGap: 16,
            children: [
              for (int i = 0; i < uimodel.gratitudeList.length; i++)
                SizedBox(
                  height: 90,
                  child: FunTile(
                    titleSmall: uimodel.gratitudeList[i].displayText,
                    assetSize: 27,
                    iconPath: uimodel.gratitudeList[i].pictureLink,
                    iconColor: uimodel.gratitudeList[i].colorCombo.darkColor,
                    onTap: () {
                      onClickTile(uimodel.gratitudeList[i]);
                    },
                    isSelected:
                        uimodel.selectedGratitude == uimodel.gratitudeList[i],
                    borderColor:
                        uimodel.gratitudeList[i].colorCombo.borderColor,
                    backgroundColor:
                        uimodel.gratitudeList[i].colorCombo.backgroundColor,
                    textColor: uimodel.gratitudeList[i].colorCombo.textColor,
                    analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.gratefulTileSelected,
                        parameters: {
                          'gratefulFor': uimodel.selectedGratitude?.displayText,
                        }),
                  ),
                ),
            ],
          ),
          const Spacer(),
          FunButton(
            isDisabled: uimodel.selectedGratitude == null,
            onTap: onNext,
            text: 'Next',
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.gratefulTileSubmitted,
              parameters: {
                'gratefulFor': uimodel.selectedGratitude?.displayText,
              },
            ),
          ),
        ],
      ),
    );
  }
}
