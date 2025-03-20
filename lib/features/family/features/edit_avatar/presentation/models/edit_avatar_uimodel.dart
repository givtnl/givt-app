import 'package:givt_app/features/family/shared/design/components/content/models/custom_avatar_uimodel.dart';

class EditAvatarUIModel {
  EditAvatarUIModel({
    required this.avatarName,
    required this.mode,
    required this.lockMessageEnabled,
    required this.customAvatarUIModel,
  });

  final String avatarName;
  final String mode;
  final bool lockMessageEnabled;
  final CustomAvatarUIModel customAvatarUIModel;
}
