import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_tabs.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class RecommendationsListWidget extends StatelessWidget {
  const RecommendationsListWidget({
    required this.uiModel,
    super.key,
    this.onRecommendationChosen,
    this.onSelectionChanged,
  });

  final RecommendationsUIModel uiModel;
  final void Function(int index)? onRecommendationChosen;
  final void Function(int index)? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 62),
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: TitleMediumText(
            '${uiModel.name} you were grateful for ${uiModel.category!.displayText.toLowerCase()}, here are some ways to help',
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: FunTabs(
            selections: [
              uiModel.showActsOfService,
              !uiModel.showActsOfService,
            ],
            onPressed: (i) => onSelectionChanged?.call(i),
            firstOption: 'Acts of Service',
            secondOption: 'Give',
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.recommendationTypeSelectorClicked,
              parameters: {
                'currentSelection':
                    uiModel.showActsOfService ? 'Acts of Service' : 'Give',
              },
            ),
          ),
        ),
        ...List.generate(
          uiModel.organisations.length,
          (index) {
            final recommendation = uiModel.organisations[index];
            return OrganisationItem(
              isActOfService: uiModel.showActsOfService,
              organisation: recommendation,
              onDonateClicked: () => onRecommendationChosen?.call(index),
              userName: uiModel.name,
            );
          },
        ),
      ],
    );
  }
}
