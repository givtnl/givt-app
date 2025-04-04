import 'package:givt_app/features/family/shared/design/components/content/models/custom_avatar_uimodel.dart';

class AvatarUIModel {
  AvatarUIModel({
    required this.text,
    this.avatar,
    this.isSelected = false,
    this.hasDonated = false,
    this.guid,
    this.customAvatarUIModel,
  });

  final bool isSelected;
  final bool hasDonated;
  final String? avatar;
  final String text;
  final String? guid;
  final CustomAvatarUIModel? customAvatarUIModel;
}
