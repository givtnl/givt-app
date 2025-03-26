import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/features/avatars/models/avatar.dart';
import 'package:givt_app/features/family/features/avatars/repositories/avatars_repository.dart';

part 'avatars_state.dart';

class AvatarsCubit extends Cubit<AvatarsState> {
  AvatarsCubit(this.avatarsRepository) : super(const AvatarsState());

  final AvatarsRepository avatarsRepository;

  Future<void> fetchAvatars() async {
    emit(state.copyWith(status: AvatarsStatus.loading, avatars: []));

    try {
      final avatars = await avatarsRepository.fetchAvatars();

      emit(state.copyWith(status: AvatarsStatus.loaded, avatars: avatars));
    } catch (e) {
      emit(state.copyWith(status: AvatarsStatus.error, error: e.toString()));
    }
  }

  void selectAvatar(String key, Avatar avatar) {
    final existingAssignmentIndex =
        state.assignedAvatars.indexWhere((element) => element.containsKey(key));

    if (existingAssignmentIndex != -1) {
      final updatedAvatars =
          List<Map<String, Avatar>>.from(state.assignedAvatars);
      updatedAvatars[existingAssignmentIndex] = {key: avatar};

      emit(state.copyWith(assignedAvatars: updatedAvatars));
    } else {
      emit(state.copyWith(
        assignedAvatars: [
          ...state.assignedAvatars,
          {key: avatar}
        ],
      ));
    }
  }

  Future<void> assignRandomAvatar(String key, int profileType) async {
    if (state.avatars.isEmpty) {
      await fetchAvatars();
    }

    final randomAvatar = profileType == 0 ? getRandomAvatarChild() : getRandomAvatarParent();

    final existingAssignmentIndex =
        state.assignedAvatars.indexWhere((element) => element.containsKey(key));

    if (existingAssignmentIndex != -1) {
      final updatedAvatars =
          List<Map<String, Avatar>>.from(state.assignedAvatars);
      updatedAvatars[existingAssignmentIndex] = {key: randomAvatar};

      emit(state.copyWith(assignedAvatars: updatedAvatars));
    } else {
      emit(state.copyWith(
        assignedAvatars: [
          ...state.assignedAvatars,
          {key: randomAvatar}
        ],
      ));
    }
  }

  Avatar getRandomAvatarChild() {
    final rand = Random().nextInt(8);
    final index = [1,2,3,5,6,7,8,9][rand];
    return state.avatars[index];
  }

  Avatar getRandomAvatarParent() {
    final rand = Random().nextInt(2);
    final index = [0,4][rand];
    return state.avatars[index];
  }

  void clear() {
    emit(state.copyWith(assignedAvatars: []));
  }
}
