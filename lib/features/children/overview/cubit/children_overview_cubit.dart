import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/repositories/children_overview_repository.dart';
import 'package:native_shared_preferences/original_shared_preferences/original_shared_preferences.dart';

part 'children_overview_state.dart';

class ChildrenOverviewCubit extends Cubit<ChildrenOverviewState> {
  ChildrenOverviewCubit(this._childrenOverviewRepository)
      : super(const ChildrenOverviewInitialState());

  final ChildrenOverviewRepository _childrenOverviewRepository;

  Future<void> fetchChildren(String parentGuid) async {
    final prefs = await SharedPreferences.getInstance();
    emit(const ChildrenOverviewLoadingState());
    final initalNumber = prefs.getInt(Profile.number) ?? 0;
    var displayAllowanceInfo = false;
    try {
      final response =
          await _childrenOverviewRepository.fetchChildren(parentGuid);
      if (response.length > initalNumber) {
        displayAllowanceInfo = true;
      }
      emit(
        ChildrenOverviewUpdatedState(
          profiles: response,
          displayAllowanceInfo: displayAllowanceInfo,
        ),
      );

      await prefs.setInt(Profile.number, response.length);
    } catch (error) {
      emit(ChildrenOverviewErrorState(errorMessage: error.toString()));
    }
  }
}
