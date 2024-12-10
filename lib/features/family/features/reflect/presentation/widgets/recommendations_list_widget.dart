import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_text_styles.dart';
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
    final cardHeight = 16 +
        40 + // action container margin and padding
        MediaQuery.textScalerOf(context)
                .scale(FunTextStyles.labelSmall.fontSize ?? 14) *
            (FunTextStyles.titleSmall.height ?? 1.2) +
        6 + // top label text and padding
        150 +
        24 + //img height and padding
        MediaQuery.textScalerOf(context)
                .scale(FunTextStyles.titleSmall.fontSize ?? 18) *
            (FunTextStyles.titleSmall.height ??
                1.2) + // big title scaled by line height and accessiblity
        48; // big title padding
    final width = MediaQuery.of(context).size.width;
    final viewportFraction = (width - 48) / width;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: cardHeight),
      child: PageView.builder(
        physics: const PageScrollPhysics(),
        itemCount: uiModel.isNotLoggedInParent && !uiModel.showActsOfService
            ? uiModel.organisations.length + 1
            : uiModel.organisations.length,
        controller: PageController(viewportFraction: viewportFraction),
        itemBuilder: (context, index) {
          if (uiModel.isNotLoggedInParent &&
              !uiModel.showActsOfService &&
              index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: TitleSmallText(
                "Right now, only the logged in parent can donate using their account. We're working on a way to allow all parents to be able to do this in the game. Stay tuned!",
                color: Colors.black.withOpacity(0.25),
              ),
            );
          }
          final recommendationIndex =
              uiModel.isNotLoggedInParent && !uiModel.showActsOfService
                  ? index - 1
                  : index;
          final recommendation = uiModel.organisations[recommendationIndex];
          return Container(
            width: width - 48,
            padding: const EdgeInsets.only(right: 12),
            child: OrganisationItem(
              isActOfService: uiModel.showActsOfService,
              organisation: recommendation,
              onDonateClicked: () =>
                  onRecommendationChosen?.call(recommendationIndex),
              userName: uiModel.name,
            ),
          );
        },
      ),
    );
  }
}
