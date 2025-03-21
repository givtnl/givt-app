import 'package:givt_app/features/family/shared/design/components/content/models/custom_avatar_uimodel.dart';

class CustomAvatarModel {
  CustomAvatarModel({
    required this.bodyIndex,
    required this.hairIndex,
    required this.maskIndex,
    required this.suitIndex,
  });
  factory CustomAvatarModel.initial() {
    return CustomAvatarModel(
      bodyIndex: 1,
      hairIndex: 0,
      maskIndex: 0,
      suitIndex: 1,
    );
  }

  factory CustomAvatarModel.fromMap(Map<String, dynamic> map) {
    return CustomAvatarModel(
      bodyIndex: map['body'] as int,
      hairIndex: map['hair'] as int,
      maskIndex: map['mask'] as int,
      suitIndex: map['suit'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Body': bodyIndex,
      'Hair': hairIndex,
      'Mask': maskIndex,
      'Suit': suitIndex,
    };
  }

  final int bodyIndex;
  final int hairIndex;
  final int maskIndex;
  final int suitIndex;

  CustomAvatarModel copyWith({
    int? bodyIndex,
    int? hairIndex,
    int? maskIndex,
    int? suitIndex,
  }) {
    return CustomAvatarModel(
      bodyIndex: bodyIndex ?? this.bodyIndex,
      hairIndex: hairIndex ?? this.hairIndex,
      maskIndex: maskIndex ?? this.maskIndex,
      suitIndex: suitIndex ?? this.suitIndex,
    );
  }

  CustomAvatarUIModel toUIModel() {
    return CustomAvatarUIModel(
      assetsToOverlap: [
        'assets/family/images/avatar/custom/Body$bodyIndex.svg',
        'assets/family/images/avatar/custom/Hair$hairIndex.svg',
        'assets/family/images/avatar/custom/Mask$maskIndex.svg',
        'assets/family/images/avatar/custom/Suit$suitIndex.svg',
      ],
      semanticsIdentifier:
          'Body$bodyIndex-Hair$hairIndex-Mask$maskIndex-Suit$suitIndex',
    );
  }
}
