class GoalProgressUIModel {
  const GoalProgressUIModel({
    required this.currentProgress,
    required this.goal,
    required this.title,
    required this.showButton,
  });

  final int currentProgress;
  final int goal;
  final String title;
  final bool showButton;
}
