import 'package:givt_app/shared/design_system/design_system.dart';

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
