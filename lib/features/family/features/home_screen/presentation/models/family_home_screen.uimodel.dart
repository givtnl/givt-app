
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';

class FamilyHomeScreenUIModel {
  const FamilyHomeScreenUIModel({
    required this.avatars,
    this.familyGroupName,
  });

  final List<AvatarUIModel> avatars;
  final String? familyGroupName;
}
