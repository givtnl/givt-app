import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/features/topup/repository/topup_repository.dart';

part 'topup_state.dart';

class TopupCubit extends Cubit<TopupState> {
  TopupCubit(this.topupRepository) : super(const TopupState());

  final TopupRepository topupRepository;

  Future<void> addMoney(int amount, bool recurring) async {
    emit(state.copyWith(status: TopupStatus.loading, amount: amount));

    try {
      if (recurring) {
        await topupRepository.setupRecurringAmount(state.userGuid, amount);
      } else {
        await topupRepository.topupChild(state.userGuid, amount);
      }

      emit(state.copyWith(status: TopupStatus.done));
    } catch (e) {
      emit(state.copyWith(status: TopupStatus.error, error: e.toString()));
    }
  }

  void setUser(String guid) {
    emit(state.copyWith(userGuid: guid, status: TopupStatus.initial));
  }

  void restart() {
    emit(state.copyWith(status: TopupStatus.initial, amount: 0));
  }
}
