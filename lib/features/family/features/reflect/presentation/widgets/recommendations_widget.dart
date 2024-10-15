import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/recommendations_list_widget.dart';
import 'package:givt_app/features/family/shared/widgets/errors/retry_error_widget.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';

class RecommendationsWidget extends StatelessWidget {
  const RecommendationsWidget({
    required this.uiModel,
    this.onRecommendationChosen,
    this.onSelectionChanged,
    this.onTapRetry,
    super.key,
  });

  final RecommendationsUIModel uiModel;
  final void Function(int index)? onRecommendationChosen;
  final void Function(int index)? onSelectionChanged;
  final void Function()? onTapRetry;

  @override
  Widget build(BuildContext context) {
    if (uiModel.isLoading) {
      return const Center(child: CustomCircularProgressIndicator());
    } else if (uiModel.hasError) {
      return RetryErrorWidget(
        onTapPrimaryButton: () => onTapRetry?.call(),
      );
    } else {
      return RecommendationsListWidget(
        uiModel: uiModel,
        onRecommendationChosen: onRecommendationChosen,
        onSelectionChanged: onSelectionChanged,
      );
    }
  }
}
