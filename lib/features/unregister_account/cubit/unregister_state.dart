part of 'unregister_cubit.dart';

abstract class UnregisterState extends Equatable {
  const UnregisterState();

  @override
  List<Object> get props => [];
}

class UnregisterInitial extends UnregisterState {
  const UnregisterInitial();

  @override
  List<Object> get props => [];
}

class UnregisterLoading extends UnregisterState {
  const UnregisterLoading();

  @override
  List<Object> get props => [];
}

class UnregisterFailure extends UnregisterState {
  const UnregisterFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class UnregisterGivy extends UnregisterState {
  const UnregisterGivy();

  @override
  List<Object> get props => [];
}

class UnregisterSuccess extends UnregisterState {
  const UnregisterSuccess();

  @override
  List<Object> get props => [];
}
