import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'generosity_allowances_state.dart';

class GenerosityAllowancesCubit extends Cubit<GenerosityAllowancesState> {
  GenerosityAllowancesCubit() : super(const GenerosityAllowancesState());

  void showAddAllowance() {
    emit(state.copyWith(status: GenerosityAddAllowanceStatus.addAllowance));
  }
}
