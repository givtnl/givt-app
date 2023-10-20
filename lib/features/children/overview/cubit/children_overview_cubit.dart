import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/repositories/children_overview_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'children_overview_state.dart';

class ChildrenOverviewCubit extends Cubit<ChildrenOverviewState> {
  ChildrenOverviewCubit(this._childrenOverviewRepository)
      : super(const ChildrenOverviewInitialState());

  final ChildrenOverviewRepository _childrenOverviewRepository;

  Future<void> fetchChildren(String parentGuid) async {
    final prefs = await SharedPreferences.getInstance();
    emit(const ChildrenOverviewLoadingState());
    final initialNumber = prefs.getInt(Profile.number) ?? 0;
    var displayAllowanceInfo = false;
    try {
      final response =
          await _childrenOverviewRepository.fetchChildren(parentGuid);
      if (response.length > initialNumber) {
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
      await LoggingInfo.instance.error(error.toString());

      emit(ChildrenOverviewErrorState(errorMessage: error.toString()));
    }
  }

  void removeDisclaimer(List<Profile> profiles) {
    emit(
      ChildrenOverviewUpdatedState(
        profiles: profiles,
        displayAllowanceInfo: false,
      ),
    );
  }
}
