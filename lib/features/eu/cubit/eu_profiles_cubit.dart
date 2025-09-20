import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/eu/models/eu_profile.dart';
import 'package:givt_app/features/eu/repository/eu_profiles_repository.dart';
import 'package:givt_app/shared/models/user_ext.dart';

part 'eu_profiles_state.dart';

class EuProfilesCubit extends Cubit<EuProfilesState> {
  EuProfilesCubit(
    this._profilesRepository,
    this._authRepository,
  ) : super(const EuProfilesInitialState()) {
    _init();
  }

  final EuProfilesRepository _profilesRepository;
  final AuthRepository _authRepository;

  StreamSubscription<List<EuProfile>>? _profilesSubscription;
  StreamSubscription<AuthState>? _authSubscription;

  void _init() {
    _profilesSubscription = _profilesRepository.onProfilesChanged().listen(
      (profiles) {
        emit(EuProfilesUpdatedState(profiles: profiles));
      },
    );
  }

  Future<void> fetchProfiles() async {
    emit(const EuProfilesLoadingState());
    try {
      final profiles = await _profilesRepository.getProfiles();
      emit(EuProfilesUpdatedState(profiles: profiles));
    } catch (e) {
      emit(EuProfilesErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> switchProfile(String profileId) async {
    try {
      await _profilesRepository.setActiveProfile(profileId);
      
      // Find the profile to switch to
      final profiles = state.profiles;
      final targetProfile = profiles.firstWhere(
        (profile) => profile.id == profileId,
        orElse: () => EuProfile.empty(),
      );

      if (targetProfile.id.isNotEmpty) {
        // In a real implementation, this would switch the auth context
        // For now, we'll just update the active profile
        emit(EuProfilesUpdatedState(profiles: profiles));
      }
    } catch (e) {
      emit(EuProfilesErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> addProfile(UserExt userExt) async {
    try {
      await _profilesRepository.addProfile(userExt);
    } catch (e) {
      emit(EuProfilesErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> removeProfile(String profileId) async {
    try {
      await _profilesRepository.removeProfile(profileId);
    } catch (e) {
      emit(EuProfilesErrorState(errorMessage: e.toString()));
    }
  }

  EuProfile? getActiveProfile() {
    try {
      return state.profiles.firstWhere((profile) => profile.isActive);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> close() {
    _profilesSubscription?.cancel();
    _authSubscription?.cancel();
    return super.close();
  }
}