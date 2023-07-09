import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/user_ext.dart';

part 'personal_info_edit_event.dart';
part 'personal_info_edit_state.dart';

class PersonalInfoEditBloc
    extends Bloc<PersonalInfoEditEvent, PersonalInfoEditState> {
  PersonalInfoEditBloc({
    required this.authRepositoy,
    required UserExt loggedInUserExt,
  }) : super(
          PersonalInfoEditState(
            loggedInUserExt: loggedInUserExt,
          ),
        ) {
    on<PersonalInfoEditEmail>(_onEmailChanged);

    on<PersonalInfoEditAddress>(_onAddressChanged);

    on<PersonalInfoEditPhoneNumber>(_onPhoneNumberChanged);

    on<PersonalInfoEditBankDetails>(_onBankDetailsChanged);

    on<PersonalInfoEditGiftAid>(_onGiftAidChanged);
  }

  final AuthRepositoy authRepositoy;

  FutureOr<void> _onEmailChanged(
    PersonalInfoEditEmail event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      await LoggingInfo.instance.info('Changing email to ${event.email}');
      if (!await authRepositoy.checkTld(event.email)) {
        emit(state.copyWith(status: PersonalInfoEditStatus.invalidEmail));
        return;
      }

      final result = await authRepositoy.checkEmail(event.email);
      if (result.contains('temp')) {
        emit(state.copyWith(status: PersonalInfoEditStatus.invalidEmail));
        return;
      }
      if (result.contains('true')) {
        emit(state.copyWith(status: PersonalInfoEditStatus.invalidEmail));
        return;
      }
      final stateUser = state.loggedInUserExt.copyWith(email: event.email);
      await authRepositoy.updateUser(
        guid: state.loggedInUserExt.guid,
        newUserExt: {
          'email': event.email,
        },
      );
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(state.copyWith(status: PersonalInfoEditStatus.noInternet));
    } on GivtServerFailure catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.error,
          error: e.body.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onAddressChanged(
    PersonalInfoEditAddress event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      await LoggingInfo.instance
          .info('Changing address to ${event..toString()}');
      final stateUser = state.loggedInUserExt.copyWith(
        address: event.address,
        city: event.city,
        country: event.country,
        postalCode: event.postalCode,
      );
      await authRepositoy.updateUserExt(
        stateUser.toUpdateJson(),
      );
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(state.copyWith(status: PersonalInfoEditStatus.noInternet));
    } on GivtServerFailure catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.error,
          error: e.body.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onPhoneNumberChanged(
    PersonalInfoEditPhoneNumber event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      await LoggingInfo.instance
          .info('Changing phone number to ${event.phoneNumber}');
      final stateUser = state.loggedInUserExt.copyWith(
        phoneNumber: event.phoneNumber,
      );
      await authRepositoy.updateUserExt(
        stateUser.toUpdateJson(),
      );
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(state.copyWith(status: PersonalInfoEditStatus.noInternet));
    } on GivtServerFailure catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.error,
          error: e.body.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onBankDetailsChanged(
    PersonalInfoEditBankDetails event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      await LoggingInfo.instance.info(
          'Changing bank details to ${event.iban} ${event.accountNumber} ${event.sortCode}');
      final stateUser = state.loggedInUserExt.copyWith(
        iban: event.iban,
        accountNumber: event.accountNumber,
        sortCode: event.sortCode,
      );
      await authRepositoy.updateUserExt(
        stateUser.toUpdateJson(),
      );
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(state.copyWith(status: PersonalInfoEditStatus.noInternet));
    } on GivtServerFailure catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.error,
          error: e.body.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onGiftAidChanged(
    PersonalInfoEditGiftAid event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      await LoggingInfo.instance
          .info('Changing gift aid to ${event.isGiftAidEnabled}');

      final stateUser = state.loggedInUserExt.copyWith(
        isGiftAidEnabled: event.isGiftAidEnabled,
      );
      await authRepositoy.changeGiftAid(
        guid: stateUser.guid,
        giftAid: event.isGiftAidEnabled,
      );

      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(state.copyWith(status: PersonalInfoEditStatus.noInternet));
    } on GivtServerFailure catch (e) {
      await LoggingInfo.instance.error(e.toString());
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.error,
          error: e.body.toString(),
        ),
      );
    }
  }
}
