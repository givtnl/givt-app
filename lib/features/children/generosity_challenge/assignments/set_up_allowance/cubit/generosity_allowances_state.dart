part of 'generosity_allowances_cubit.dart';

class GenerosityAllowancesState extends Equatable {
  const GenerosityAllowancesState({
    this.status = GenerosityAddAllowanceStatus.walletIntro,
  });

  final GenerosityAddAllowanceStatus status;

  @override
  List<Object> get props => [status];

  GenerosityAllowancesState copyWith({
    GenerosityAddAllowanceStatus? status,
  }) {
    return GenerosityAllowancesState(
      status: status ?? this.status,
    );
  }
}

enum GenerosityAddAllowanceStatus {
  walletIntro,
  addAllowance,
  addAllowanceSuccess,
  ;
}
