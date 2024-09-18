import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_tags_data.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GratitudeSelectionScreen extends StatelessWidget {
  const GratitudeSelectionScreen({super.key});

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
              for (int i = 0;
                  i < GratitudeTagsData.gratitudeCategories.length;
                  i++)
                SizedBox(
                  height: 90,
                  child: FunTile(
                    titleSmall:
                        GratitudeTagsData.gratitudeCategories[i].displayText,
                    assetSize: 27,
                    iconPath:
                        GratitudeTagsData.gratitudeCategories[i].pictureLink,
                    iconColor: GratitudeTagsData
                        .gratitudeCategories[i].colorCombo.darkColor,
                    onTap: () {},
                    isSelected: false,
                    borderColor: GratitudeTagsData
                        .gratitudeCategories[i].colorCombo.borderColor,
                    backgroundColor: GratitudeTagsData
                        .gratitudeCategories[i].colorCombo.backgroundColor,
                    textColor: GratitudeTagsData
                        .gratitudeCategories[i].colorCombo.textColor,
                  ),
                ),
            ],
          ),
          const Spacer(),
          FunButton(
            //isDisabled if one of the tags is selected
            isDisabled: false,
            onTap: () {
              // push guess the word screen
            },
            text: 'Next',
            analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.gratefulForNextClicked,
                parameters: {
                  //  selectedTag disolay name
                  'gratefulFor': 'Text',
                }),
          ),
        ],
      ),
    );
  }
}
