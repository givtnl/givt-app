import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/utils/utils.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({required this.authRepositoy, required this.authCubit})
      : super(const RegistrationState()) {
    on<RegistrationPasswordSubmitted>(_onRegistrationPasswordSubmitted);

    on<RegistrationPersonalInfoSubmitted>(_onRegistrationPersonalInfoSubmitted);

    on<RegistrationSignMandate>(_onSignMandate);

    on<RegistrationInit>(_onInit);

    on<RegistrationGiftAidChanged>(_onGiftAidChanged);

    on<RegistrationStripeSuccess>(_onStripeSuccess);

    on<RegistrationStripeInit>(_onStripeInit);
  }

  final AuthRepository authRepositoy;
  final AuthCubit authCubit;

  FutureOr<void> _onRegistrationPasswordSubmitted(
    RegistrationPasswordSubmitted event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(status: RegistrationStatus.loading));
    emit(
      state.copyWith(
        status: RegistrationStatus.personalInfo,
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        password: event.password,
      ),
    );
  }

  FutureOr<void> _onRegistrationPersonalInfoSubmitted(
    RegistrationPersonalInfoSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(status: RegistrationStatus.loading));

    try {
      final tempUser = TempUser(
        email: state.email,
        country: event.country,
        appLanguage: event.appLanguage,
        timeZoneId: await FlutterTimezone.getLocalTimezone(),
        amountLimit:
            event.country.toUpperCase() == Country.us.countryCode ? 4999 : 499,
        address: event.address,
        city: event.city,
        firstName: state.firstName,
        iban: event.iban,
        lastName: state.lastName,
        password: state.password,
        phoneNumber: event.phoneNumber,
        postalCode: event.postalCode,
        accountNumber: event.accountNumber,
        sortCode: event.sortCode,
      );

      await authRepositoy.registerUser(
        tempUser: tempUser,
        isNewUser: false,
      );

      await authCubit.refreshUser(forceAuthUpdate: true);
      if (event.country.toUpperCase() == Country.us.countryCode) {
        emit(
          state.copyWith(
            status: RegistrationStatus.createStripeAccount,
          ),
        );
        return;
      }
      if (event.iban.isNotEmpty && event.iban != Util.defaultIban) {
        emit(
          state.copyWith(
            status: RegistrationStatus.sepaMandateExplanation,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          status: RegistrationStatus.bacsDirectDebitMandateExplanation,
        ),
      );
    } catch (e, stackTrace) {
      log(e.toString());
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(status: RegistrationStatus.failure),
      );
    }
  }

  FutureOr<void> _onSignMandate(
    RegistrationSignMandate event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(status: RegistrationStatus.loading));

    try {
      final response = await authRepositoy.signSepaMandate(
        appLanguage: event.appLanguage,
        guid: event.guid,
      );
      log(response);

      await authCubit.refreshUser();
      await authCubit.refreshSession();
      final user = authCubit.state.user;
      if (user.sortCode.isNotEmpty && user.accountNumber.isNotEmpty) {
        emit(
          state.copyWith(
            status: RegistrationStatus.bacsDirectDebitMandateSigned,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          status: RegistrationStatus.success,
        ),
      );
    } on GivtServerFailure catch (e, stackTrace) {
      final statusCode = e.statusCode;
      final body = e.body;
      log(body.toString());
      LoggingInfo.instance.error(
        body.toString(),
        methodName: stackTrace.toString(),
      );
      if (statusCode == 409) {
        emit(
          state.copyWith(
            status: RegistrationStatus.conflict,
          ),
        );
        return;
      }
      if (statusCode == 400) {
        emit(
          state.copyWith(
            status: RegistrationStatus.badRequest,
          ),
        );
        return;
      }
      emit(
        state.copyWith(status: RegistrationStatus.failure),
      );
    } catch (e, stackTrace) {
      log(e.toString());
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(status: RegistrationStatus.failure),
      );
    }
  }

  FutureOr<void> _onInit(
    RegistrationInit event,
    Emitter<RegistrationState> emit,
  ) async {
    LoggingInfo.instance.info(
      'Registration Init',
      methodName: StackTrace.current.toString(),
    );
    emit(state.copyWith(status: RegistrationStatus.loading));

    final user = authCubit.state.user;
    if (user.accountNumber.isNotEmpty && user.sortCode.isNotEmpty) {
      emit(
        state.copyWith(
          status: RegistrationStatus.bacsDirectDebitMandateExplanation,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: RegistrationStatus.sepaMandateExplanation,
      ),
    );
  }

  void _onStripeInit(
    RegistrationStripeInit event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(status: RegistrationStatus.createStripeAccount));
  }

  Future<void> _onStripeSuccess(
    RegistrationStripeSuccess event,
    Emitter<RegistrationState> emit,
  ) async {
    var user = authCubit.state.user;

    var trials = 1;
    var delayTime = 5;

    while (user.tempUser && trials < 257) {
      //get current state of user in givt system
      ///and update it in the app
      await authCubit.refreshUser(emitAuthentication: event.emitAuthenticated);
      user = authCubit.state.user;
      log('trial number $trials, delay time is $delayTime,\n   user is temporary: ${user.tempUser}');

      if (trials > 16) {
        delayTime = 60;
      }
      trials++;
      await Future<void>.delayed(Duration(seconds: delayTime));
    }

    if (user.tempUser == false) {
      await authCubit.refreshSession(
          emitAuthentication: event.emitAuthenticated,);
      emit(state.copyWith(status: RegistrationStatus.success));
    } else {
      emit(state.copyWith(status: RegistrationStatus.failure));
    }
  }

  FutureOr<void> _onGiftAidChanged(
    RegistrationGiftAidChanged event,
    Emitter<RegistrationState> emit,
  ) async {
    final guid = authCubit.state.user.guid;
    emit(state.copyWith(status: RegistrationStatus.loading));

    try {
      final response = await authRepositoy.changeGiftAid(
        guid: guid,
        giftAid: event.isGiftAidEnabled,
      );
      log(response.toString());

      await authCubit.refreshUser();
      emit(
        state.copyWith(
          status: RegistrationStatus.giftAidChanged,
        ),
      );
    } catch (e, stackTrace) {
      log(e.toString());
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(status: RegistrationStatus.failure),
      );
    }
  }
}
