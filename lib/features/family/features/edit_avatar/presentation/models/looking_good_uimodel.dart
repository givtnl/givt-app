import 'package:givt_app/features/family/shared/design/components/content/models/custom_avatar_uimodel.dart';

class LookingGoodUIModel {
  LookingGoodUIModel({
    required this.userFirstName,
    required this.possessiveFirstName,
    this.avatar,
    this.customAvatarUIModel,
  });

  final String? avatar;
  final CustomAvatarUIModel? customAvatarUIModel;
  final String userFirstName;
  final String possessiveFirstName;
}
