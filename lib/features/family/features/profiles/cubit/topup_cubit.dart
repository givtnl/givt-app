import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/features/profiles/repository/topup_repository.dart';

part 'topup_state.dart';

class TopupCubit extends Cubit<TopupState> {
  TopupCubit(this.topupRepository) : super(const TopupState());

  final TopupRepository topupRepository;

  Future<void> topup(int amount) async {
    emit(state.copyWith(status: TopupStatus.loading));

    try {
      await topupRepository.topupChild(state.userGuid, amount);
      emit(state.copyWith(status: TopupStatus.done));
    } catch (e) {
      // emit(state.copyWith(status: TopupStatus.error, error: e.toString()));
    }
  }

  void setUser(String guid) {
    emit(state.copyWith(userGuid: guid, status: TopupStatus.initial));
  }

  void restart() {
    emit(state.copyWith(status: TopupStatus.initial));
  }
}
