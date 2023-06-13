import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(const RegistrationInitial()) {
    on<RegistrationPasswordSubmitted>(_onRegistrationPasswordSubmitted);
  }

  FutureOr<void> _onRegistrationPasswordSubmitted(
    RegistrationPasswordSubmitted event,
    Emitter<RegistrationState> emit,
  ) {
    emit(const RegistrationLoading());
    emit(
      RegistrationPassword(
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        password: event.password,
      ),
    );
  }
}
