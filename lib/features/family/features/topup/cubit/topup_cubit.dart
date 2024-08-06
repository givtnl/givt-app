import 'package:bloc/bloc.dart';
import 'package:givt_app/features/family/features/topup/repository/topup_repository.dart';

part 'topup_state.dart';

class TopupCubit extends Cubit<TopupState> {
  TopupCubit(this.topupRepository) : super(const InitialState());

  final TopupRepository topupRepository;
  String? userGuid;

  void init(String guid) {
    userGuid = guid;

    emit(const InitialState());
  }

  Future<void> addMoney(int amount, bool recurring) async {
    emit(const LoadingState());

    try {
      if (recurring) {
        await topupRepository.setupRecurringAmount(userGuid!, amount);
      } else {
        await topupRepository.topupChild(userGuid!, amount);
      }

      emit(SuccessState(amount, recurring));
    } catch (e) {
      emit(const ErrorState());
    }
  }
}
