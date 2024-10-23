part of 'connection_cubit.dart';

sealed class ConnectionState extends Equatable {
  const ConnectionState();

  @override
  List<Object> get props => [];
}

final class ConnectionInitial extends ConnectionState {}

final class ConnectionLive extends ConnectionState {}

final class ConnectionLost extends ConnectionState {}
