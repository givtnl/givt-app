import 'dart:async';

import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

mixin CreateTransactionRepository {
  Future<void> createTransaction({required Transaction transaction});

  Stream<void> onTransaction();
}

class CreateTransactionRepositoryImpl with CreateTransactionRepository {
  CreateTransactionRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;
  final StreamController<void> _transactionCreatedController =
      StreamController<void>.broadcast();

  @override
  Future<void> createTransaction({required Transaction transaction}) async {
    await _apiService.createTransaction(transaction: transaction);
    _transactionCreatedController.add(null);
  }

  @override
  Stream<void> onTransaction() => _transactionCreatedController.stream;
}
