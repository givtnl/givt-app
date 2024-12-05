import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class RecommendationsListWidget extends StatelessWidget {
  const RecommendationsListWidget({
    required this.uiModel,
    super.key,
    this.onRecommendationChosen,
  });

  final RecommendationsUIModel uiModel;
  final void Function(int index)? onRecommendationChosen;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // TODO - Remake OrganisationItem to not need vertical height restriction and remove this
      constraints: BoxConstraints(
        minHeight: 200,
        maxHeight: MediaQuery.of(context).size.height / 2,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 24, right: 24),
        children: [
          if (uiModel.isNotLoggedInParent && !uiModel.showActsOfService)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: TitleSmallText(
                "Right now, only the logged in parent can donate using their account. We're working on a way to allow all parents to be able to do this in the game. Stay tuned!",
                color: Colors.black.withOpacity(0.25),
              ),
            ),
          ...List.generate(
            uiModel.organisations.length,
            (index) {
              final recommendation = uiModel.organisations[index];
              return Container(
                width: MediaQuery.of(context).size.width - 48,
                padding: const EdgeInsets.only(right: 12),
                child: OrganisationItem(
                  isActOfService: uiModel.showActsOfService,
                  organisation: recommendation,
                  onDonateClicked: () => onRecommendationChosen?.call(index),
                  userName: uiModel.name,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
