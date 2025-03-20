import 'dart:async';

import 'package:givt_app/features/family/features/gratitude_goal/domain/models/behavior_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/models/set_a_goal_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/repositories/gratitude_goal_repository.dart';
import 'package:givt_app/features/family/features/gratitude_goal/presentation/models/gratitude_goal_commit_custom.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GratitudeGoalCommitCubit
    extends CommonCubit<AvatarBarUIModel?, GratitudeGoalCommitCustom> {
  GratitudeGoalCommitCubit(
    this._profilesRepository,
    this._gratitudeGoalRepository,
    this._reflectAndShareRepository,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final GratitudeGoalRepository _gratitudeGoalRepository;
  final ReflectAndShareRepository _reflectAndShareRepository;

  List<Profile> profiles = [];

  void init() {
    _getProfiles();
  }

  Future<void> _getProfiles() async {
    emitLoading();
    profiles = await _profilesRepository.getProfiles();
    _emitData();
  }

  void _emitData() {
    emitData(profiles.isEmpty
        ? null
        : AvatarBarUIModel(
            avatarUIModels: profiles
                .map(
                  (e) => AvatarUIModel(
                    avatar: e.avatar,
                    text: e.firstName,
                    guid: e.id,
                  ),
                )
                .toList(),
          ));
  }

  Future<void> onTapCommitToThisGoal(
    SetAGoalOptions chosenOption,
    BehaviorOptions behavior,
  ) async {
    try {
      final result =
          await _gratitudeGoalRepository.submit(chosenOption, behavior);
      if (result) {
        unawaited(_reflectAndShareRepository.refreshGameStats());
        emitCustom(const GratitudeGoalCommitCustom.navigateToHome());
      } else {
        _emitError();
      }
    } catch (e, s) {
      _emitError();
    }
  }

  void _emitError() {
    emitSnackbarMessage(
      'Oops, something went wrong. Check your internet connection and try again.',
      isError: true,
    );
    emitCustom(
      const GratitudeGoalCommitCustom.setButtonLoading(isLoading: false),
    );
  }
}
