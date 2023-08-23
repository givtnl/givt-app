// ignore_for_file: cascade_invocations

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/repositories/children_overview_repository.dart';

part 'children_overview_state.dart';

class ChildrenOverviewCubit extends Cubit<ChildrenOverviewState> {
  ChildrenOverviewCubit(this._childrenOverviewRepository)
      : super(const ChildrenOverviewInitialState());

  final ChildrenOverviewRepository _childrenOverviewRepository;

  Future<void> fetchChildren(String parentGuid) async {
    emit(const ChildrenOverviewLoadingState());

    try {
      final response =
          await _childrenOverviewRepository.fetchChildren(parentGuid);
      emit(ChildrenOverviewUpdatedState(profiles: response));
    } catch (error) {
      emit(ChildrenOverviewErrorState(errorMessage: error.toString()));
    }
  }
}
