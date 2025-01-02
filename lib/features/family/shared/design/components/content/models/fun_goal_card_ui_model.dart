class FunGoalCardUIModel {
  FunGoalCardUIModel({
    required this.title,
    this.description = 'Completed',
    this.progress = 100,
  });

  final String title;
  final String description;
  final double progress;
}
