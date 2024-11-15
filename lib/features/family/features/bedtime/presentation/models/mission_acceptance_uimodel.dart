import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';

class MissionAcceptanceUIModel {
  const MissionAcceptanceUIModel({
    required this.avatarBarUIModel,
    required this.familyName,
  });

  final AvatarBarUIModel avatarBarUIModel;
  final String familyName;
}
