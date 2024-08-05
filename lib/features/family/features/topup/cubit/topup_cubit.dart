import 'package:bloc/bloc.dart';
import 'package:givt_app/features/family/features/topup/repository/topup_repository.dart';

part 'topup_state.dart';

class TopupCubit extends Cubit<TopupState> {
  TopupCubit(this.topupRepository) : super(const InitialState('', 5, false));

  final TopupRepository topupRepository;

  Future<void> addMoney(int amount, bool recurring) async {
    emit(LoadingState(state.userGuid, amount, recurring));

    try {
      if (recurring) {
        await topupRepository.setupRecurringAmount(state.userGuid, amount);
      } else {
        await topupRepository.topupChild(state.userGuid, amount);
      }

      emit(SuccessState(state.userGuid, amount, recurring));
    } catch (e) {
      emit(ErrorState(state.userGuid, amount, recurring, e.toString()));
    }
  }

  void setUser(String guid) {
    emit(InitialState(guid, 5, false));
  }

  void restart() {
    emit(InitialState(state.userGuid, state.amount, state.recurring));
  }
}
