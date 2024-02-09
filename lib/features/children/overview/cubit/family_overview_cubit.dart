import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/repositories/family_overview_repository.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'family_overview_state.dart';

class FamilyOverviewCubit extends Cubit<FamilyOverviewState> {
  FamilyOverviewCubit(this._familyOverviewRepository)
      : super(const FamilyOverviewInitialState());

  final FamilyOverviewRepository _familyOverviewRepository;

  Future<void> fetchFamilyProfiles(String parentGuid) async {
    final prefs = await SharedPreferences.getInstance();
    emit(const FamilyOverviewLoadingState());
    final initialNumber = prefs.getInt(Profile.number) ?? 0;
    var displayAllowanceInfo = false;
    try {
      final response = await _familyOverviewRepository.fetchFamily(parentGuid);
      if (response.length > initialNumber) {
        displayAllowanceInfo = true;
      }
      emit(
        FamilyOverviewUpdatedState(
          profiles: response,
          displayAllowanceInfo: displayAllowanceInfo,
        ),
      );

      await prefs.setInt(Profile.number, response.length);
    } catch (error) {
      await LoggingInfo.instance.error(error.toString());

      emit(FamilyOverviewErrorState(errorMessage: error.toString()));
    }
  }

  void removeDisclaimer(List<Profile> profiles) {
    emit(
      FamilyOverviewUpdatedState(
        profiles: profiles,
        displayAllowanceInfo: false,
      ),
    );
  }
}
