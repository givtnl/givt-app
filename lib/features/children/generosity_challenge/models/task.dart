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
  });

  const Task.card({
    required this.image,
    required this.title,
    required this.description,
    required this.onTap,
    required this.buttonText,
  }) : type = TaskType.card;

  final TaskType type;
  final String image;
  final String title;
  final String description;
  final void Function() onTap;
  final String buttonText;

  @override
  List<Object> get props =>
      [type, image, title, description, buttonText, onTap];
}
