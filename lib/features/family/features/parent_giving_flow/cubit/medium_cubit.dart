import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'medium_state.dart';

class MediumCubit extends Cubit<MediumState> {
  MediumCubit() : super(const MediumState());

  void setMediumId(String mediumId) {
    emit(state.copyWith(mediumId: mediumId));
  }
}
