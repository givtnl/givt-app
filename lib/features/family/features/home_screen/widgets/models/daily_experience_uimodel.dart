class DailyExperienceUIModel {
  DailyExperienceUIModel({
    required this.timeLeft,
    required this.currentProgress,
    required this.total,
  });

  final DateTime timeLeft;
  final int currentProgress;
  final int total;
}
