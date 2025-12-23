import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/give/models/givt_transaction.dart';
import 'package:givt_app/utils/analytics_helper.dart';

part 'give_state.dart';

class GiveCubit extends Cubit<GiveState> {
  GiveCubit(
    this._createTransactionRepository,
    this._reflectAndShareRepository,
  ) : super(GiveInitial());
  final CreateTransactionRepository _createTransactionRepository;
  final ReflectAndShareRepository _reflectAndShareRepository;

  Future<void> createTransaction({
    required String userId,
    required int amount,
    required String orgName,
    required String mediumId,
    bool isGratitude = false,
    int? experiencePoints,
  }) async {
    emit(GiveLoading());
    final transaction = Transaction(
      userId: userId,
      amount: amount.toDouble(),
      mediumId: base64Encode(utf8.encode(mediumId)),
      isActOfService: isGratitude,
      gameGuid: isGratitude ? _reflectAndShareRepository.getGameId() : null,
    );
    try {
      await _createTransactionRepository.createTransaction(
        transaction: transaction,
      );

      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.parentGaveSuccessfully,
        eventProperties: {
          'amount': transaction.amount,
          'organisation': orgName,
          'mediumid': mediumId,
          'experiencePoints': experiencePoints,
        },
      );
      emit(
        GiveFromBrowser(
          GivtTransaction.fromTransaction(transaction),
          transaction,
          orgName,
          mediumId,
          experiencePoints,
        ),
      );
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        'Error while creating transaction: $error',
        methodName: stackTrace.toString(),
      );
      emit(const GiveError('Error creating transaction.'));
    }
  }

  void reset() {
    emit(GiveInitial());
  }
}
