import 'package:equatable/equatable.dart';

enum TaskType {
  card,
}

class Task extends Equatable {
  const Task({
    required this.type,
    required this.image,
    required this.title,
    required this.description,
    required this.onTap,
    required this.buttonText,
    required this.feedbackImage,
    required this.feedbackTitle,
    required this.feedbackContent,
  });

  const Task.card({
    required this.image,
    required this.title,
    required this.description,
    required this.onTap,
    required this.buttonText,
    this.feedbackImage =
        'assets/images/generosity_challenge_feedback_badge.svg',
    this.feedbackTitle = 'Awesome!',
    this.feedbackContent = 'You made it!',
  }) : type = TaskType.card;

  final TaskType type;
  final String image;
  final String title;
  final String description;
  final void Function() onTap;
  final String buttonText;
  final String feedbackImage;
  final String feedbackTitle;
  final String feedbackContent;

  @override
  List<Object> get props => [
        type,
        image,
        title,
        description,
        buttonText,
        onTap,
        feedbackImage,
        feedbackTitle,
        feedbackContent,
      ];
}
