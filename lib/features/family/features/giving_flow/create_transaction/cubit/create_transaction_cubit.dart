import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'create_transaction_state.dart';

class CreateTransactionCubit extends Cubit<CreateTransactionState> {
  CreateTransactionCubit(
    this._profilesCubit,
    this._profilesRepository,
    this._createTransactionRepository,
  ) : super(
          CreateTransactionChooseAmountState(
            amount: 0,
            maxAmount: _profilesCubit.state.activeProfile.wallet.balance,
          ),
        );

  final ProfilesCubit _profilesCubit;
  final ProfilesRepository _profilesRepository;
  final CreateTransactionRepository _createTransactionRepository;

  void changeAmount(double amount) {
    emit(
      CreateTransactionChooseAmountState(
        amount: amount.roundToDouble(),
        maxAmount:
            _profilesCubit.state.activeProfile.wallet.balance.roundToDouble(),
      ),
    );
  }

  Future<void> fetchActiveProfileBalance() async {
    emit(const CreateTransactionLoadingState());
    await _profilesCubit.fetchAllProfiles();
    emit(
      CreateTransactionChooseAmountState(
        amount: state.amount,
        maxAmount: _profilesCubit.state.activeProfile.wallet.balance,
      ),
    );
  }

  Future<void> createTransaction({required Transaction transaction}) async {
    emit(
      CreateTransactionUploadingState(
          amount: state.amount, maxAmount: state.maxAmount),
    );

    try {
      await _createTransactionRepository.createTransaction(
        transaction: transaction,
      );
      if(_profilesCubit.state.activeProfile.isChild) {
        await _profilesRepository.refreshChildDetails(transaction.userId);
      } else {
        await _profilesRepository.refreshProfiles();
      }
      emit(
        CreateTransactionSuccessState(
          amount: state.amount,
          maxAmount: state.maxAmount,
        ),
      );
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        'Error while creating transaction: $error',
        methodName: stackTrace.toString(),
      );
      emit(
        CreateTransactionErrorState(
          amount: state.amount,
          maxAmount: state.maxAmount,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
