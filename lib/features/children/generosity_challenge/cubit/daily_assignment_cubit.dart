import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'daily_assignment_state.dart';

class DailyAssignmentCubit extends Cubit<DailyAssignmentState> {
  DailyAssignmentCubit() : super(const DailyAssignmentState());

  void complete() =>
      emit(const DailyAssignmentState(status: DailyAssignmentStatus.completed));
  void completedFlow(String description) => emit(
        DailyAssignmentState(
          status: DailyAssignmentStatus.confirm,
          dynamicDescription: description,
        ),
      );
}
