import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';

class RecommendationsWidget extends StatelessWidget {
  const RecommendationsWidget(
      {required this.uiModel, super.key, this.onRecommendationChosen});

  final RecommendationsUIModel uiModel;
  final void Function(int index)? onRecommendationChosen;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 62),
      children: [
        const SizedBox(height: 24),
        TitleMediumText(
          true == uiModel.name?.isNotNullAndNotEmpty()
              ? "${uiModel.name}, here's some non-profits you could support!"
              : "Here's some non-profits you could support!",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ...List.generate(
          uiModel.organisations.length,
          (index) {
            final recommendation = uiModel.organisations[index];
            return OrganisationItem(
              organisation: recommendation,
              onDonateClicked: () => onRecommendationChosen?.call(index),
            );
          },
        ),
      ],
    );
  }
}
