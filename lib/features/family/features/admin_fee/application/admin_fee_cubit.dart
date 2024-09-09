import 'dart:async';

import 'package:givt_app/features/family/features/admin_fee/data/repositories/admin_fee_repository.dart';
import 'package:givt_app/features/family/features/admin_fee/domain/models/admin_fee.dart';
import 'package:givt_app/features/family/features/admin_fee/presentation/models/admin_fee_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class AdminFeeCubit extends CommonCubit<AdminFeeUIModel, dynamic> {
  AdminFeeCubit(this._repository) : super(const BaseState.loading()) {
    _subscription = _repository.adminFeeStream().listen(emitState);
  }

  final AdminFeeRepository _repository;
  StreamSubscription<AdminFee>? _subscription;
  double? _amount;

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }

  void setAmount(double amount) {
    if (_amount != amount) {
      _amount = amount;
      final fee = _repository.adminFee;
      emitState(fee);
    }
  }

  void emitState(AdminFee fee) {
    if (_amount != null) {
      emitData(fee.toUIModel(_amount!));
    }
  }
}
