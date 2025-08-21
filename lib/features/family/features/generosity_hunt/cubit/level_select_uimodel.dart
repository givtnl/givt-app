part of 'level_select_cubit.dart';

class LevelSelectUIModel {
  const LevelSelectUIModel({this.selectedLevel, this.levels = const []});

  final int? selectedLevel;
  final List<LevelUIModel> levels;
}

class LevelUIModel {

  LevelUIModel({
    required this.level,
    required this.itemsNeeded,
    required this.funFact,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.assignment,
    this.imageAsset = 'assets/family/images/barcode_hunt/level_default_image.svg',
    this.isUnlocked = false,
    this.isCompleted = false,
  });

  factory LevelUIModel.fromJson(Map<String, dynamic> json) {
    return LevelUIModel(
      level: json['level'] as int,
      itemsNeeded: json['itemsNeeded'] as int,
      funFact: json['funFact'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      assignment: json['assignment'] as String? ?? '',
    );
  }

  final int level;
  final int itemsNeeded;
  final String funFact;
  final String title;
  final String subtitle;
  final String description;
  final String assignment;
  final String imageAsset;
  bool isUnlocked;
  bool isCompleted;

}
