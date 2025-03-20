import 'package:givt_app/features/family/shared/design/components/content/models/custom_avatar_uimodel.dart';

class CustomAvatarModel {
  CustomAvatarModel({
    required this.bodyIndex,
    required this.hairIndex,
    required this.maskIndex,
    required this.suitIndex,
  });

  factory CustomAvatarModel.fromMap(Map<String, dynamic> map) {
    return CustomAvatarModel(
      bodyIndex: map['Body'] as int,
      hairIndex: map['Hair'] as int,
      maskIndex: map['Mask'] as int,
      suitIndex: map['Suit'] as int,
    );
  }

  factory CustomAvatarModel.initial() {
    return CustomAvatarModel(
      bodyIndex: 0,
      hairIndex: 0,
      maskIndex: 0,
      suitIndex: 0,
    );
  }

  final int bodyIndex;
  final int hairIndex;
  final int maskIndex;
  final int suitIndex;

  CustomAvatarUIModel toUIModel() {
    return CustomAvatarUIModel(
      assetsToOverlap: [
        'assets/avatars/custom/Body$bodyIndex.svg',
        'assets/avatars/custom/Hair$hairIndex.svg',
        'assets/avatars/custom/Mask$maskIndex.svg',
        'assets/avatars/custom/Suit$suitIndex.svg',
      ],
      semanticsIdentifier:
          'Body$bodyIndex-Hair$hairIndex-Mask$maskIndex-Suit$suitIndex',
    );
  }
}
