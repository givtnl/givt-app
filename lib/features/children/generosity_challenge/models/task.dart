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
    required this.feedbackTitle,
    required this.feedbackLabel,
    required this.feedbackImage,
    this.partnerCard,
    this.redirect,
  });

  const Task.card({
    required this.image,
    required this.title,
    required this.description,
    required this.onTap,
    this.buttonText = '',
    this.partnerCard,
    this.redirect,
    this.feedbackImage =
        'assets/images/generosity_challenge_feedback_badge.svg',
    this.feedbackTitle = '',
    this.feedbackLabel = 'New Reward',
  }) : type = TaskType.card;

  final TaskType type;
  final String image;
  final String title;
  final String description;
  final void Function() onTap;
  final String buttonText;
  final String feedbackImage;
  final String feedbackTitle;
  final String feedbackLabel;
  final Task? partnerCard;
  final String? redirect;

  @override
  List<Object?> get props => [
        type,
        image,
        title,
        description,
        buttonText,
        onTap,
        partnerCard,
        redirect,
      ];
}
