import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';

part 'unregister_state.dart';

class UnregisterCubit extends Cubit<UnregisterState> {
  UnregisterCubit(this.authRepositoy) : super(const UnregisterInitial());

  final AuthRepository authRepositoy;

  Future<void> unregister({
    required String email,
  }) async {
    emit(const UnregisterLoading());
    try {
      await authRepositoy.unregisterUser(email: email);
      emit(const UnregisterGivy());
      await Future.delayed(const Duration(seconds: 5), () {
        emit(const UnregisterSuccess());
      });
    } on GivtServerFailure catch (e, stackTrace) {
      final statusCode = e.statusCode;
      final body = e.body;
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      if (statusCode >= 300 && body != null) {
        if (!body.containsKey('AdditionalInformation')) {
          emit(
            UnregisterFailure(
              e.toString(),
            ),
          );
          return;
        }
        final additionalInformation =
            body['AdditionalInformation'] as Map<String, dynamic>;
        if (additionalInformation.containsKey('errorTerm')) {
          final error = additionalInformation['errorTerm'] as String;
          emit(
            UnregisterFailure(
              error,
            ),
          );
          return;
        }
      }
      emit(
        UnregisterFailure(
          e.toString(),
        ),
      );
    } on SocketException catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        const UnregisterNoInternet(),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        UnregisterFailure(
          e.toString(),
        ),
      );
    }
  }
}
