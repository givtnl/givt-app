import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';

class RecommendationsWidget extends StatelessWidget {
  const RecommendationsWidget({required this.uiModel, super.key, this.onRecommendationChosen});

  final RecommendationsUIModel uiModel;
  final void Function(int index)? onRecommendationChosen;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
