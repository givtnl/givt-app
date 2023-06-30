import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/overview/models/givt.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

part 'givt_event.dart';
part 'givt_state.dart';

class GivtBloc extends Bloc<GivtEvent, GivtState> {
  GivtBloc(this.givtRepository) : super(const GivtInitial()) {
    on<GivtInit>(_onGivtInit);
  }

  final GivtRepository givtRepository;

  FutureOr<void> _onGivtInit(GivtInit event, Emitter<GivtState> emit) async {
    emit(const GivtLoading());
    try {
      final unsortedGivts = await givtRepository.fetchGivts();
      emit(GivtLoaded(unsortedGivts));
    } catch (e) {
      log(e.toString());
      // emit(const GivtError());
    }
  }
}
