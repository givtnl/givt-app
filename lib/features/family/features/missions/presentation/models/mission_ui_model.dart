class MissionUIModel {
  MissionUIModel({
    required this.title,
    required this.description,
    this.progress = 0,
  });

  final String title;
  final String description;
  final double progress;
}
