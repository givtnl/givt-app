import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/gratitude_selection_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GratitudeSelectionWidget extends StatelessWidget {
  const GratitudeSelectionWidget({
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
    return Scrollbar(
      child: FunScaffold(
        minimumPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        canPop: false,
        appBar: const FunTopAppBar(
          title: 'Question 3',
          actions: [
            LeaveGameButton(),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
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
                          for (int i = 0; i < uimodel.tagList.length; i++)
                            FunTile(
                              shrink: true,
                              titleMedium: uimodel.tagList[i].displayText,
                              assetSize: 27,
                              iconPath: '',
                              iconData: uimodel.tagList[i].iconData,
                              iconColor:
                                  uimodel.tagList[i].colorCombo.darkColor,
                              onTap: () {
                                onClickTile(uimodel.tagList[i]);
                              },
                              isSelected:
                                  uimodel.selectedTag == uimodel.tagList[i],
                              borderColor:
                                  uimodel.tagList[i].colorCombo.borderColor,
                              backgroundColor:
                                  uimodel.tagList[i].colorCombo.backgroundColor,
                              textColor:
                                  uimodel.tagList[i].colorCombo.textColor,
                              analyticsEvent: AnalyticsEventName
                                  .gratefulTileSelected
                                  .toEvent(
                                    parameters: {
                                      'gratefulFor':
                                          uimodel.selectedTag?.displayText,
                                    },
                                  ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(
                        height: 56 + 24,
                      ), // Placeholder for the button
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 24, top: 8),
                child: FunButton(
                  isDisabled: uimodel.selectedTag == null,
                  onTap: onNext,
                  text: 'Last Question',
                  analyticsEvent: AnalyticsEventName.gratefulTileSubmitted.toEvent(
                    parameters: {
                      'superhero': uimodel.superheroName,
                      'gratefulFor': uimodel.selectedTag?.displayText,
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
