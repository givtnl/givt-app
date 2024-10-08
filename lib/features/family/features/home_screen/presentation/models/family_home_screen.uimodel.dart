import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_uimodel.dart';

class FamilyHomeScreenUIModel {
  const FamilyHomeScreenUIModel({
    required this.avatars,
    this.familyGroupName,
  });

  final List<GratefulAvatarUIModel> avatars;
  final String? familyGroupName;
}
