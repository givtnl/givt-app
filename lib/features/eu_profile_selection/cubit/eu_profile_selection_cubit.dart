import 'dart:async';
import 'package:givt_app/features/eu_profile_selection/models/eu_profile.dart';
import 'package:givt_app/features/eu_profile_selection/models/eu_profile_selection_uimodel.dart';
import 'package:givt_app/features/eu_profile_selection/models/eu_profile_selection_custom.dart';
import 'package:givt_app/features/eu_profile_selection/repository/eu_profile_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

/// Cubit responsible for managing EU profile selection state.
/// Uses [EuProfileRepository] for fetching profile data.
class EuProfileSelectionCubit extends CommonCubit<EuProfileSelectionUIModel, EuProfileSelectionCustom> {
  EuProfileSelectionCubit(this._repository) : super(const BaseState.loading());

  final EuProfileRepository _repository;
  StreamSubscription<List<EuProfile>>? _profilesSubscription;

  Future<void> init() async {
    _profilesSubscription = _repository.onProfilesChanged().listen(_onProfilesChanged);
    await loadProfiles();
  }

  void _onProfilesChanged(List<EuProfile> profiles) {
    _emitData();
  }

  Future<void> loadProfiles() async {
    await inTryCatchFinally(
      inTry: () async {
        print('EU Profile Selection: Starting to load profiles');
        emitLoading();
        await _repository.getProfiles();
        
        print('EU Profile Selection: Profiles loaded');
        _emitData();
        print('EU Profile Selection: State emitted as loaded');
      },
      inCatch: (e, s) async {
        print('EU Profile Selection: Error loading profiles: $e');
        emitError(e.toString());
      },
    );
  }

  void selectProfile(String profileId) {
    _emitData();
  }

  Future<void> setActiveProfile(String profileId) async {
    await _repository.setActiveProfile(profileId);
    _emitData();
  }

  void navigateToProfile(String profileId) {
    emitCustom(NavigateToProfile(profileId));
  }

  void showAddProfileDialog() {
    emitCustom(const ShowAddProfileDialog());
  }

  void _emitData() {
    final profiles = _repository.getProfilesSync() ?? [];
    final activeProfileId = _repository.getActiveProfileId();
    
    final uiModel = EuProfileSelectionUIModel(
      profiles: profiles,
      selectedProfileId: activeProfileId ?? profiles.firstOrNull?.id,
      isLoading: false,
    );
    
    emitData(uiModel);
  }

  @override
  Future<void> close() {
    _profilesSubscription?.cancel();
    return super.close();
  }
}

