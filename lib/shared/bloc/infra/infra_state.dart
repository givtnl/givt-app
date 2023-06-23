part of 'infra_cubit.dart';

abstract class InfraState extends Equatable {
  const InfraState();

  @override
  List<Object> get props => [];
}

class InfraInitial extends InfraState {
  const InfraInitial();

  @override
  List<Object> get props => [];
}

class InfraLoading extends InfraState {
  const InfraLoading();

  @override
  List<Object> get props => [];
}

class InfraSuccess extends InfraState {
  const InfraSuccess();

  @override
  List<Object> get props => [];
}

class InfraFailure extends InfraState {
  const InfraFailure();

  @override
  List<Object> get props => [];
}



