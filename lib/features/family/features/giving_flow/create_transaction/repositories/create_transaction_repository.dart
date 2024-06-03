import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app/features/family/network/api_service.dart';

mixin CreateTransactionRepository {
  Future<void> createTransaction({required Transaction transaction});
}

class CreateTransactionRepositoryImpl with CreateTransactionRepository {
  CreateTransactionRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<void> createTransaction({required Transaction transaction}) async {
    await _apiService.createTransaction(transaction: transaction);
  }
}
