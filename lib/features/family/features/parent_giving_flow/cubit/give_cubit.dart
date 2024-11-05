import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/give/models/givt_transaction.dart';
import 'package:givt_app/shared/models/collect_group.dart';

part 'give_state.dart';

class GiveCubit extends Cubit<GiveState> {
  GiveCubit(
    this._createTransactionRepository,
  ) : super(GiveInitial());
  final CreateTransactionRepository _createTransactionRepository;

  Future<void> createTransaction(
      {required Transaction transaction,
      required String orgName,
      required String mediumId}) async {
    emit(GiveLoading());
    try {
      await _createTransactionRepository.createTransaction(
        transaction: transaction,
      );
      emit(GiveFromBrowser(GivtTransaction.fromTransaction(transaction),
          transaction, orgName, mediumId));
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
