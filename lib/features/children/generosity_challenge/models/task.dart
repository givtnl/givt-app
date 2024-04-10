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
  });

  const Task.card({
    required this.image,
    required this.title,
    required this.description,
  }) : type = TaskType.card;

  final TaskType type;
  final String image;
  final String title;
  final String description;

  @override
  List<Object> get props => [type, image, title, description];
}
