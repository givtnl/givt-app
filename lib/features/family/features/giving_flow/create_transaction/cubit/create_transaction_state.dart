part of 'create_transaction_cubit.dart';

abstract class CreateTransactionState extends Equatable {
  const CreateTransactionState({required this.amount, required this.maxAmount});

  final double amount;
  final double maxAmount;

  @override
  List<Object> get props => [amount, maxAmount];
}

class CreateTransactionChooseAmountState extends CreateTransactionState {
  const CreateTransactionChooseAmountState({
    required super.amount,
    required super.maxAmount,
  });
}

class CreateTransactionUploadingState extends CreateTransactionState {
  const CreateTransactionUploadingState({
    required super.amount,
    required super.maxAmount,
  });
}

class CreateTransactionSuccessState extends CreateTransactionState {
  const CreateTransactionSuccessState({
    required super.amount,
    required super.maxAmount,
  });
}

class CreateTransactionErrorState extends CreateTransactionState {
  const CreateTransactionErrorState({
    required super.amount,
    required super.maxAmount,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [amount, maxAmount, errorMessage];
}
