import 'package:equatable/equatable.dart';

class Day extends Equatable {
  const Day({
    required this.dateCompleted,
  });

  Day.byDateTime({required DateTime dateTime})
      : dateCompleted = dateTime.toIso8601String();

  const Day.empty() : dateCompleted = '';

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        dateCompleted: (json['dateCompleted'] ?? '').toString(),
      );

  final String dateCompleted;

  Map<String, dynamic> toJson() {
    return {
      'dateCompleted': dateCompleted,
    };
  }

  bool get isCompleted => dateCompleted.isNotEmpty;

  @override
  List<Object> get props => [dateCompleted];
}
