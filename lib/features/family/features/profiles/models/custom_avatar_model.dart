import 'package:givt_app/features/family/shared/design/components/content/models/custom_avatar_uimodel.dart';

class CustomAvatarModel {
  CustomAvatarModel({
    required this.bodyIndex,
    required this.hairIndex,
    required this.maskIndex,
    required this.suitIndex,
    this.hairColor = '#282A25',
    this.maskColor,
    this.suitColor,
  });
  factory CustomAvatarModel.initial() {
    return CustomAvatarModel(
      bodyIndex: 1,
      hairIndex: 0,
      maskIndex: 0,
      suitIndex: 1,
    );
  }

  factory CustomAvatarModel.initialSjoerd() {
    return CustomAvatarModel(
      bodyIndex: 6,
      hairIndex: 0,
      maskIndex: 666,
      suitIndex: 666,
    );
  }

  factory CustomAvatarModel.initialTine() {
    return CustomAvatarModel(
      bodyIndex: 6,
      hairIndex: 666,
      maskIndex: 669,
      suitIndex: 667,
    );
  }

  factory CustomAvatarModel.fromMap(Map<String, dynamic> map) {
    return CustomAvatarModel(
      bodyIndex: map['body'] as int,
      hairIndex: map['hair'] as int,
      maskIndex: map['mask'] as int,
      suitIndex: map['suit'] as int,
      hairColor: map['hairColor'] as String? ?? '#282A25',
      maskColor: map['maskColor'] as String?,
      suitColor: map['suitColor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Body': bodyIndex,
      'Hair': hairIndex,
      'Mask': maskIndex,
      'Suit': suitIndex,
      'HairColor': hairColor,
      'MaskColor': maskColor,
      'SuitColor': suitColor,
    };
  }

  final int bodyIndex;
  final int hairIndex;
  final int maskIndex;
  final int suitIndex;
  final String hairColor;
  final String? maskColor;
  final String? suitColor;

  CustomAvatarModel copyWith({
    int? bodyIndex,
    int? hairIndex,
    int? maskIndex,
    int? suitIndex,
    String? hairColor,
    String? maskColor,
    String? suitColor,
  }) {
    return CustomAvatarModel(
      bodyIndex: bodyIndex ?? this.bodyIndex,
      hairIndex: hairIndex ?? this.hairIndex,
      maskIndex: maskIndex ?? this.maskIndex,
      suitIndex: suitIndex ?? this.suitIndex,
      hairColor: hairColor ?? this.hairColor,
      maskColor: maskColor ?? this.maskColor,
      suitColor: suitColor ?? this.suitColor,
    );
  }

  CustomAvatarUIModel toUIModel() {
    return CustomAvatarUIModel(
      hairColor: hairColor,
      maskColor: maskColor,
      suitColor: suitColor,
      assetsToOverlap: [
        'assets/family/images/avatar/custom/Body$bodyIndex.svg',
        'assets/family/images/avatar/custom/Hair$hairIndex.svg',
        'assets/family/images/avatar/custom/Mask$maskIndex.svg',
        'assets/family/images/avatar/custom/Suit$suitIndex.svg',
      ],
      semanticsIdentifier:
          'Body$bodyIndex-Hair$hairIndex-Mask$maskIndex-Suit$suitIndex-HairColor$hairColor-MaskColor$maskColor-SuitColor$suitColor',
    );
  }
}
