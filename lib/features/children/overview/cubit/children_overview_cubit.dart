import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/repositories/children_overview_repository.dart';
import 'package:native_shared_preferences/original_shared_preferences/original_shared_preferences.dart';

part 'children_overview_state.dart';

class ChildrenOverviewCubit extends Cubit<ChildrenOverviewState> {
  ChildrenOverviewCubit(this._childrenOverviewRepository, this._prefs)
      : super(const ChildrenOverviewInitialState());

  final ChildrenOverviewRepository _childrenOverviewRepository;
  final SharedPreferences _prefs;
  Future<void> fetchChildren(String parentGuid) async {
    emit(const ChildrenOverviewLoadingState());
    final initalNumber = _prefs.getInt(Profile.number) ?? 0;
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

      await _prefs.setInt(Profile.number, response.length);
    } catch (error) {
      emit(ChildrenOverviewErrorState(errorMessage: error.toString()));
    }
  }
}
