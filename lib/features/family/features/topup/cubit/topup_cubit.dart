import 'package:bloc/bloc.dart';
import 'package:givt_app/features/children/edit_child/repositories/edit_child_repository.dart';

part 'topup_state.dart';

class TopupCubit extends Cubit<TopupState> {
  TopupCubit(this.editChildRepository) : super(const InitialState());

  final EditChildRepository editChildRepository;
  String? userGuid;

  void init(String guid) {
    userGuid = guid;

    emit(const InitialState());
  }

  Future<void> addMoney(int amount, bool recurring) async {
    emit(const LoadingState());

    try {
      if (recurring) {
        await editChildRepository.editChildAllowance(userGuid!, amount);
      } else {
        await editChildRepository.topUpChild(userGuid!, amount);
      }

      emit(SuccessState(amount, recurring));
    } catch (e) {
      emit(const ErrorState());
    }
  }
}
