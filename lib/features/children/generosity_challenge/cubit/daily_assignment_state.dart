part of 'daily_assignment_cubit.dart';

class DailyAssignmentState extends Equatable {
  const DailyAssignmentState({
    this.status = DailyAssignmentStatus.initial,
    this.dynamicDescription,
  });

  final DailyAssignmentStatus status;
  final String? dynamicDescription;
  @override
  List<Object?> get props => [status, dynamicDescription];

  DailyAssignmentState copyWith({
    DailyAssignmentStatus? status,
    String? dynamicDescription,
  }) {
    return DailyAssignmentState(
      status: status ?? this.status,
      dynamicDescription: dynamicDescription,
    );
  }
}

enum DailyAssignmentStatus { initial, confirm, completed }
