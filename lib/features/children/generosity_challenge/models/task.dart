import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum TaskType {
  card,
}

class Task extends Equatable {
  const Task({
    required this.type,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.feedbackTitle,
    required this.feedbackLabel,
    required this.feedbackImage,
    this.partnerCard,
    this.customBottomWidget,
    this.redirect,
  });

  const Task.card({
    required this.image,
    required this.title,
    required this.description,
    this.buttonText = '',
    this.partnerCard,
    this.redirect,
    this.feedbackImage =
        'assets/images/generosity_challenge_feedback_badge.svg',
    this.feedbackTitle = '',
    this.feedbackLabel = 'New Reward',
    this.customBottomWidget,
  }) : type = TaskType.card;

  final TaskType type;
  final String image;
  final String title;
  final String description;
  final String buttonText;
  final String feedbackImage;
  final String feedbackTitle;
  final String feedbackLabel;
  final Task? partnerCard;
  final String? redirect;
  final Widget? customBottomWidget;

  @override
  List<Object?> get props => [
        type,
        image,
        title,
        description,
        buttonText,
        partnerCard,
        redirect,
        customBottomWidget,
      ];
}
