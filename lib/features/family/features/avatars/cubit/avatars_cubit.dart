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

  Future<void> assignRandomAvatarUrl(String key) async {
    if (state.avatars.isEmpty) {
      await fetchAvatars();
    }

    final randomAvatar = getRandomAvatar();

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

  Avatar getAvatarByKey(String key) {
    final assignment = state.assignedAvatars
        .firstWhere((element) => element.containsKey(key), orElse: () => {});

    return assignment[key] ?? const Avatar.empty();
  }

  Avatar getRandomAvatar() {
    final index = Random().nextInt(state.avatars.length - 1);
    return state.avatars[index];
  }
}
