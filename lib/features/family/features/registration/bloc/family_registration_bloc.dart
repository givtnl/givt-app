import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/registration/domain/registration_repository.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/utils/util.dart';

part 'family_registration_event.dart';
part 'family_registration_state.dart';

class FamilyRegistrationBloc
    extends Bloc<FamilyRegistrationEvent, FamilyRegistrationState> {
  FamilyRegistrationBloc({
    required this.authRepository,
    required this.registrationRepository,
  }) : super(const FamilyRegistrationState()) {
    on<FamilyPersonalInfoSubmitted>(_onRegistrationPersonalInfoSubmitted);

    on<FamilyRegistrationInit>(_onInit);

    on<FamilyRegistrationReset>(_onReset);
  }

  final FamilyAuthRepository authRepository;
  final FamilyRegistrationRepository registrationRepository;

  FutureOr<void> _onRegistrationPersonalInfoSubmitted(
    FamilyPersonalInfoSubmitted event,
    Emitter<FamilyRegistrationState> emit,
  ) async {
    emit(state.copyWith(status: FamilyRegistrationStatus.loading));

    try {
      final tempUser = TempUser(
        email: state.email,
        country: event.country,
        appLanguage: event.appLanguage,
        timeZoneId: await FlutterTimezone.getLocalTimezone(),
        amountLimit:
            event.country.toUpperCase() == Country.us.countryCode ? 4999 : 499,
        address: Util.defaultAdress,
        city: Util.defaultCity,
        postalCode: Util.defaultPostCode,
        firstName: state.firstName,
        iban: Util.defaultIban,
        lastName: state.lastName,
        password: state.password,
        phoneNumber: event.phoneNumber,
        accountNumber: Util.empty,
        sortCode: Util.empty,
        profilePicture: event.profilePicture,
      );

      await authRepository.registerUser(
        tempUser: tempUser,
        isNewUser: false,
      );
    } catch (e, stackTrace) {
      log(e.toString());
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );

      emit(
        state.copyWith(status: FamilyRegistrationStatus.failure),
      );
    }
  }

  FutureOr<void> _onInit(
    FamilyRegistrationInit event,
    Emitter<FamilyRegistrationState> emit,
  ) async {
    LoggingInfo.instance.info(
      'Family Registration Init',
      methodName: StackTrace.current.toString(),
    );
    emit(state.copyWith(status: FamilyRegistrationStatus.loading));
  }

  FutureOr<void> _onReset(
    FamilyRegistrationReset event,
    Emitter<FamilyRegistrationState> emit,
  ) {
    emit(const FamilyRegistrationState());
  }

  void finishedRegistrationFlow() {
    registrationRepository.userHasFinishedRegistrationFlow();
  }
}
