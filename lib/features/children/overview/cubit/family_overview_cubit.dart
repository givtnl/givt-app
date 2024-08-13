import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'family_overview_state.dart';

class FamilyOverviewCubit extends Cubit<FamilyOverviewState> {
  FamilyOverviewCubit(this._profilesRepository)
      : super(const FamilyOverviewInitialState()) {
    _init();
  }

  StreamSubscription<List<Profile>>? _profilesSubscription;
  final ProfilesRepository _profilesRepository;

  Future<void> _init() async {
   _profilesSubscription = _profilesRepository.profilesStream().listen((profiles) {
      fetchFamilyProfiles();
    });
  }

  Future<void> fetchFamilyProfiles({bool showAllowanceWarning = false}) async {
    emit(const FamilyOverviewLoadingState());

    final prefs = await SharedPreferences.getInstance();
    final initialNumber = prefs.getInt(Profile.number) ?? 0;
    var displayAllowanceInfo = false;

    if (showAllowanceWarning) {
      emit(const FamilyOverviewAllowanceWarningState());
    }
    try {
      final response = await _profilesRepository.getProfiles();
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
    } catch (error, stackTrace) {
      LoggingInfo.instance
          .error(error.toString(), methodName: stackTrace.toString());

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

  @override
  Future<void> close() async {
    await _profilesSubscription?.cancel();
    await super.close();
  }
}
