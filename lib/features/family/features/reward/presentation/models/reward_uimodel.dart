import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';

class RewardUIModel {
  RewardUIModel({
    required this.rewardText,
    required this.rewardImage,
    this.interviewUIModel,
    this.useDefaultInterviewIcon = true,
    this.triggerAppReview = false,
  });

  final String rewardText;
  final String? rewardImage;
  final FunDialogUIModel? interviewUIModel;
  final bool useDefaultInterviewIcon;
  final bool triggerAppReview;
}
