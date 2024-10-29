part of 'internet_connection_cubit.dart';

sealed class InternetConnectionState extends Equatable {
  const InternetConnectionState();

  @override
  List<Object> get props => [];
}

final class InternetConnectionInitial extends InternetConnectionState {}

final class InternetConnectionLive extends InternetConnectionState {}

final class InternetConnectionLost extends InternetConnectionState {}
