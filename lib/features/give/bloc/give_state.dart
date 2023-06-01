part of 'give_cubit.dart';

abstract class GiveState extends Equatable {
  const GiveState();

  @override
  List<Object> get props => [];
}

class GiveInitial extends GiveState {}

class GiveLoading extends GiveState {}

class GiveError extends GiveState {}

class GiveLoaded extends GiveState {
  const GiveLoaded({required this.organisation});
  final Organisation organisation;

  @override
  List<Object> get props => [organisation];
}
