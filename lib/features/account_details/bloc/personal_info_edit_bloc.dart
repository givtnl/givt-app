import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/shared/models/user_ext.dart';

part 'personal_info_edit_event.dart';
part 'personal_info_edit_state.dart';

class PersonalInfoEditBloc
    extends Bloc<PersonalInfoEditEvent, PersonalInfoEditState> {
  PersonalInfoEditBloc({
    required this.authRepository,
    required UserExt loggedInUserExt,
  }) : super(
          PersonalInfoEditState(
            loggedInUserExt: loggedInUserExt,
          ),
        ) {
    on<PersonalInfoEditName>(_onNameChanged);

    on<PersonalInfoEditEmail>(_onEmailChanged);

    on<PersonalInfoEditAddress>(_onAddressChanged);

    on<PersonalInfoEditPhoneNumber>(_onPhoneNumberChanged);

    on<PersonalInfoEditBankDetails>(_onBankDetailsChanged);

    on<PersonalInfoEditGiftAid>(_onGiftAidChanged);

    on<PersonalInfoEditChangeMaxAmount>(_onMaxAmountChanged);
  }

  final AuthRepository authRepository;

  void _handleSocketException(
    Exception e,
    StackTrace stackTrace,
    Emitter<PersonalInfoEditState> emit,
  ) {
    LoggingInfo.instance.error(
      e.toString(),
      methodName: stackTrace.toString(),
    );
    emit(state.copyWith(status: PersonalInfoEditStatus.noInternet));
  }

  void _handleGivtServerFailure(
    GivtServerFailure e,
    StackTrace stackTrace,
    Emitter<PersonalInfoEditState> emit,
  ) {
    LoggingInfo.instance.error(
      e.toString(),
      methodName: stackTrace.toString(),
    );
    emit(
      state.copyWith(
        status: PersonalInfoEditStatus.error,
        error: e.body.toString(),
      ),
    );
  }

  void _handleGenericException(
    Object e,
    StackTrace stackTrace,
    Emitter<PersonalInfoEditState> emit,
  ) {
    LoggingInfo.instance.error(
      e.toString(),
      methodName: stackTrace.toString(),
    );
    final hasInternet = getIt<NetworkInfo>().isConnected;
    emit(
      state.copyWith(
        status: hasInternet
            ? PersonalInfoEditStatus.error
            : PersonalInfoEditStatus.noInternet,
      ),
    );
  }

  FutureOr<void> _onNameChanged(
    PersonalInfoEditName event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      LoggingInfo.instance.info(
        'Changing name to ${event.firstName} ${event.lastName}',
      );

      final stateUser = state.loggedInUserExt.copyWith(
        firstName: event.firstName,
        lastName: event.lastName,
      );
      await authRepository.updateUserExt(
        stateUser.toUpdateJson(),
      );
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e, stackTrace) {
      _handleSocketException(e, stackTrace, emit);
    } on GivtServerFailure catch (e, stackTrace) {
      _handleGivtServerFailure(e, stackTrace, emit);
    } catch (e, stackTrace) {
      _handleGenericException(e, stackTrace, emit);
    }
  }

  FutureOr<void> _onEmailChanged(
    PersonalInfoEditEmail event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      LoggingInfo.instance.info('Changing email to ${event.email}');
      if (!await authRepository.checkTld(event.email)) {
        emit(state.copyWith(status: PersonalInfoEditStatus.invalidEmail));
        return;
      }

      final result = await authRepository.checkEmail(event.email);
      if (result.contains('temp')) {
        emit(state.copyWith(status: PersonalInfoEditStatus.invalidEmail));
        return;
      }
      if (result.contains('true')) {
        emit(state.copyWith(status: PersonalInfoEditStatus.invalidEmail));
        return;
      }
      final stateUser = state.loggedInUserExt.copyWith(email: event.email);
      await authRepository.updateUser(
        guid: state.loggedInUserExt.guid,
        newUserExt: {
          'amountLimit': state.loggedInUserExt.amountLimit,
          'email': event.email,
        },
      );
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e, stackTrace) {
      _handleSocketException(e, stackTrace, emit);
    } on GivtServerFailure catch (e, stackTrace) {
      _handleGivtServerFailure(e, stackTrace, emit);
    } catch (e, stackTrace) {
      _handleGenericException(e, stackTrace, emit);
    }
  }

  FutureOr<void> _onAddressChanged(
    PersonalInfoEditAddress event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      LoggingInfo.instance.info('Changing address to ${event..toString()}');
      final stateUser = state.loggedInUserExt.copyWith(
        address: event.address,
        city: event.city,
        country: event.country,
        postalCode: event.postalCode,
      );
      await authRepository.updateUserExt(
        stateUser.toUpdateJson(),
      );
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e, stackTrace) {
      _handleSocketException(e, stackTrace, emit);
    } on GivtServerFailure catch (e, stackTrace) {
      _handleGivtServerFailure(e, stackTrace, emit);
    } catch (e, stackTrace) {
      _handleGenericException(e, stackTrace, emit);
    }
  }

  FutureOr<void> _onPhoneNumberChanged(
    PersonalInfoEditPhoneNumber event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      LoggingInfo.instance
          .info('Changing phone number to ${event.phoneNumber}');
      final stateUser = state.loggedInUserExt.copyWith(
        phoneNumber: event.phoneNumber,
      );
      await authRepository.updateUserExt(
        stateUser.toUpdateJson(),
      );
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e, stackTrace) {
      _handleSocketException(e, stackTrace, emit);
    } on GivtServerFailure catch (e, stackTrace) {
      _handleGivtServerFailure(e, stackTrace, emit);
    } catch (e, stackTrace) {
      _handleGenericException(e, stackTrace, emit);
    }
  }

  FutureOr<void> _onBankDetailsChanged(
    PersonalInfoEditBankDetails event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      LoggingInfo.instance.info(
        'Changing bank details to ${event.iban} ${event.accountNumber} ${event.sortCode}',
      );

      final cleanedIban = event.iban.replaceAll(' ', '');

      final stateUser = state.loggedInUserExt.copyWith(
        iban: cleanedIban,
        accountNumber: event.accountNumber,
        sortCode: event.sortCode,
      );
      await authRepository.updateUserExt(
        stateUser.toUpdateJson(),
      );
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e, stackTrace) {
      _handleSocketException(e, stackTrace, emit);
    } on GivtServerFailure catch (e, stackTrace) {
      _handleGivtServerFailure(e, stackTrace, emit);
    } catch (e, stackTrace) {
      _handleGenericException(e, stackTrace, emit);
    }
  }

  FutureOr<void> _onGiftAidChanged(
    PersonalInfoEditGiftAid event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      LoggingInfo.instance
          .info('Changing gift aid to ${event.isGiftAidEnabled}');

      final stateUser = state.loggedInUserExt.copyWith(
        isGiftAidEnabled: event.isGiftAidEnabled,
      );
      await authRepository.changeGiftAid(
        guid: stateUser.guid,
        giftAid: event.isGiftAidEnabled,
      );

      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e, stackTrace) {
      _handleSocketException(e, stackTrace, emit);
    } on GivtServerFailure catch (e, stackTrace) {
      _handleGivtServerFailure(e, stackTrace, emit);
    } catch (e, stackTrace) {
      _handleGenericException(e, stackTrace, emit);
    }
  }

  FutureOr<void> _onMaxAmountChanged(
    PersonalInfoEditChangeMaxAmount event,
    Emitter<PersonalInfoEditState> emit,
  ) async {
    emit(state.copyWith(status: PersonalInfoEditStatus.loading));
    try {
      LoggingInfo.instance
          .info('Changing max amount to ${event.newAmountLimit}');
      final stateUser = state.loggedInUserExt.copyWith(
        amountLimit: event.newAmountLimit,
      );
      await authRepository.updateUser(
        guid: state.loggedInUserExt.guid,
        newUserExt: {
          'amountLimit': event.newAmountLimit,
          'email': state.loggedInUserExt.email,
        },
      );
      emit(
        state.copyWith(
          status: PersonalInfoEditStatus.success,
          loggedInUserExt: stateUser,
        ),
      );
    } on SocketException catch (e, stackTrace) {
      _handleSocketException(e, stackTrace, emit);
    } on GivtServerFailure catch (e, stackTrace) {
      _handleGivtServerFailure(e, stackTrace, emit);
    } catch (e, stackTrace) {
      _handleGenericException(e, stackTrace, emit);
    }
  }
}
