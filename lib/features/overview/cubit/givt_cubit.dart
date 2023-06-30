import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/overview/models/givt.dart';
import 'package:givt_app/shared/repositories/repositories.dart';

part 'givt_state.dart';

class GivtCubit extends Cubit<GivtState> {
  GivtCubit(this.givtRepository) : super(const GivtInitial());

  final GivtRepository givtRepository;

  Future<void> fetchGivts() async {
    emit(const GivtLoading());
    try {
      final unSortedGivts = await givtRepository.fetchGivts();
      // final givts = unSortedGivts.sort((a, b) {

      // });

      emit(GivtLoaded(unSortedGivts));
    } catch (_) {
      emit(const GivtError());
    }
  }
}
