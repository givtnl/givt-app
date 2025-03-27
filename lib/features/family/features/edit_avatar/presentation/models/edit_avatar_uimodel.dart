import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_item_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/custom_avatar_uimodel.dart';

class EditAvatarUIModel {
  EditAvatarUIModel({
    required this.userId,
    required this.avatarName,
    required this.mode,
    required this.lockMessageEnabled,
    required this.isFeatureUnlocked,
    required this.customAvatarUIModel,
    required this.bodyItems,
    required this.hairItems,
    required this.maskItems,
    required this.suitItems,
  });

  final String userId;
  final String avatarName;
  final String mode;
  final bool lockMessageEnabled;
  final bool isFeatureUnlocked;
  final CustomAvatarUIModel customAvatarUIModel;
  final List<EditAvatarItemUIModel> bodyItems;
  final List<EditAvatarItemUIModel> hairItems;
  final List<EditAvatarItemUIModel> maskItems;
  final List<EditAvatarItemUIModel> suitItems;
}
