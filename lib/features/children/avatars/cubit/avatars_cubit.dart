import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/avatars/models/avatar.dart';
import 'package:givt_app/features/children/avatars/repositories/avatars_repository.dart';

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
}
