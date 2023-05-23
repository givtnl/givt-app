part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);
  final UserExt user;

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {}
