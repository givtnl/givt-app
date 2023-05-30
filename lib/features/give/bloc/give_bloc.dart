import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'give_event.dart';
part 'give_state.dart';

class GiveBloc extends Bloc<GiveEvent, GiveState> {
  GiveBloc() : super(GiveInitial()) {
    on<GiveEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
